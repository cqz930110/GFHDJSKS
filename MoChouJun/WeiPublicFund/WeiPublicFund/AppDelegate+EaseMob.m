

/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate+EaseMob.h"
#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "ApplyViewController.h"
#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "User.h"
#import "AddressBookManage.h"
#import "ChatBuddyDAO.h"
#import "ReflectUtil.h"
/**
 *  本类中做了EaseMob初始化和推送等操作
 */
static const CGFloat kDefaultPlaySoundInterval = 10.0;
@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    [[EaseSDKHelper shareHelper] easemobApplication:application
                    didFinishLaunchingWithOptions:launchOptions
                                           appkey:appkey
                                     apnsCertName:apnsCertName
                                      otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:NO]}];
    [self registerEaseMobNotification];
     NSString *haviLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KHaveLogin];
    if (![haviLogin isEqualToString:@"YES"])
    { 
        WelcomeViewController *vc = [[WelcomeViewController alloc]init];
        self.window.rootViewController = vc;
    }
    else
    {
        BaseNavigationController *navigationController;
        if (self.mainController == nil)
        {
            self.mainController = [[TabBarController alloc] init];
            navigationController = [[BaseNavigationController alloc] initWithRootViewController:self.mainController];
        }
        else
        {
            navigationController  = (BaseNavigationController *)self.mainController.navigationController;
        }
        self.window.rootViewController = navigationController;
    }
    
    // 创建数据成功
    [[AddressBookManage addressBookManage].addressBook requestAccess:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSLog(@"可以访问通讯录");
         }
         else
         {
             NSLog(@"用户不同意访问你的通讯录");
         }
     }];
}

#pragma mark - App Delegate
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - EMChatManagerBuddyDelegate

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    
    if (!message) {
        message = @"对方请求添加你为好友";
    }
    
    //好友判断
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"FriendApply/CheckFriend" parameters:@{@"UserName":username} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            NSString *valueStr = [dic valueForKey:@"StatusId"];//好友状态 0 正常 1黑名单 3不是好友
            PSChat *chat = [ReflectUtil reflectDataWithClassName:@"PSChat" otherObject:dic];
            [ChatBuddyDAO updateChatBuddy:chat];
            if ([valueStr integerValue] == 0)
            {
                [self requestLoadSystemNotificationMessage:[NSString stringWithFormat:@"%@同意你的好友申请",username]];
            }
            else if ([valueStr integerValue] == 1)
            {
                
            }
            else if ([valueStr integerValue] == 3)
            {
                NSDictionary *applyDic = @{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]};
                [self playSoundAndVibration];
                [[ApplyViewController shareController] addNewApply:applyDic];
                if (self.mainController)
                {
                    [self.mainController setupUntreatedApplyCount];
                }
            }
        }
    }];
}

#pragma mark - 播放响铃和震动
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

#pragma mark - Request
- (void)requestLoadSystemNotificationMessage:(NSString *)message
{
    NetWorkingUtil *httpUtil = [NetWorkingUtil netWorkingUtil];
    [httpUtil requestDic4MethodName:@"DynaMsg/AddMsg" parameters:@{@"Message":message} result:^(NSDictionary *dic, int status, NSString *msg) {
        
    }];
}

#pragma mark - EMChatManagerGroupDelegate
// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:@"你被从群组\'%@\'中踢出", tmpStr];
    }
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:group.groupId deleteMessages:YES append2Chat:YES];
    
    if (str.length > 0) {
        [self requestLoadSystemNotificationMessage:str];
    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    if (!reason || reason.length == 0)
    {
        reason = [NSString stringWithFormat:@"被拒绝加入群组\'%@\'", groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'", username, groupname];
    }
    else
    {
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'：%@", username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:@"发送申请失败:%@\n原因：%@", reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
        [[ApplyViewController shareController] addNewApply:dic];
        if (self.mainController) {
            [self.mainController setupUntreatedApplyCount];
        }
    }
}

// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if(error){
        return;
    }
//#warning todo - 添加群组提示
}

#pragma mark - EMChatManagerUtilDelegate

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [self.mainController networkChanged:connectionState];
}

#pragma mark - EMPushManagerDelegateDevice

// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error)
    {
        NSLog(@"绑定Device失败");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification
{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
