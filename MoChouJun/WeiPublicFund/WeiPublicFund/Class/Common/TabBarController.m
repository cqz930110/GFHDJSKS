//
//  TabBarController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "WeiCrowdfundingViewController.h"
#import "MyCenterViewController.h"
#import "ConversationListController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "User.h"
#import "IOSmd5.h"
#import "RequestAddressUtil.h"
#import "ShowAdManager.h"
#import "ChatBuddyDAO.h"
#import "PSChat.h"
#import "InvitationManager.h"
//#import "ChatFriendDAO.h"
#import "PSBuddy.h"
#import "ReflectUtil.h"
#import "McjHomeViewController.h"
#import "StartFirstProjectViewController.h"
#import "IphoneBindingViewController.h"
#import "CheckNameViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 10.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface TabBarController ()<UIAlertViewDelegate, IChatManagerDelegate>{
    ConversationListController *_circelViewController;
    McjHomeViewController * _homeVC;
    
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation TabBarController

+ (void)initialize
{
    //统一设置 Navi Bar
    [self setAppearanceNaviBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.title = @"首页";
    
    if (![_type isEqual:@"back"]) {
        // user 更新
        [self updateUserInfo];
        // 自动登录
        [self autoLogin];
        
        [self registerNotifications];
        [self addObserver];
        
        [self setupViewControllers];
        
        [self setupUnreadMessageCount];
        [self setupUntreatedApplyCount];
        
        _ok = NO;
        // 获取用户好友列表
        
        // 获取用户群组列表
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 更新手机通讯录
    [self updatePhoneContact];
    [self showAdImgae];
}

- (void)showAdImgae
{
    [[[ShowAdManager alloc] init] show];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - Request
//- (void)requestLoginWithUsername:(NSString *)username password:(NSString *)password
//{
//    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
//    [util requestDic4MethodName:@"Auth/Login" parameters:@{@"UserName":username,@"Password":password} result:^(NSDictionary *dic, int status, NSString *msg)
//     {
//         if (status == 1)
//         {
//             User *user = [User shareUser];
//             user.Id = [dic valueForKey:@"Id"];
//             user.nickName = [dic valueForKey:@"NickName"];
//             user.avatar = [dic valueForKey:@"Avatar"];
//             user.password = password;
//             user.mobile = [dic valueForKey:@"Mobile"];
//             user.userName = [dic valueForKey:@"UserName"];
//             user.realName = [dic valueForKey:@"RealName"];
//             user.isOtherLogin = NO;
//             // 环信登录
//             NSString *passwordMD5 = [IOSmd5 md5:user.password];
//             passwordMD5 = [IOSmd5 md5:passwordMD5];
//            [self loginWithUsername:user.userName password:passwordMD5];
//         }
//         else
//         {
//             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败，是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
//             alertView.tag = 102;
//             [alertView show];
//             [[User shareUser] clearData];
//         }
//     }];
//}

#pragma mark - EaseLogin
- (void)hxLoginWithUsername:(NSString *)username password:(NSString *)password
{
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error)
         {
             User *userInfo = [User shareUser];
             [userInfo saveUser];
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
             [[EaseMob sharedInstance].chatManager disableAutoLogin];
             [[EaseMob sharedInstance].chatManager setApnsNickname:userInfo.nickName];
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             [[ApplyViewController shareController] loadDataSourceFromLocalDB];
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
             
             // 更新好友列表
//             [self requestUpdateFirendList];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败，是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
             alertView.tag = 103;
             [alertView show];
             [[User shareUser] clearData];
         }
     } onQueue:nil];
}

// 更新好友列表
//- (void)requestUpdateFirendList
//{
//    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/List" parameters:@{@"PageIndex":@1,@"PageSize":@1000} result:^(NSArray *arr, int status, NSString *msg)
//     {
//         if (status == 1)
//         {
//             NSArray *buddys = [ChatFriendDAO allChatFriends];
//             [ChatFriendDAO deleteChatFriends:[buddys valueForKeyPath:@"userName"]];
//
//             if (arr.count)
//             {
//                 [ChatFriendDAO updateChatFriends:arr];
//             }
//         }
//         else
//         {
//             if (![msg isEqualToString:@"操作成功"])
//             {
//                 [MBProgressHUD showError:msg toView:self.view];
//             }
//         }
//     } convertClassName:@"PSBuddy" key:@"DataSet"];
//}

#pragma mark - Private
- (void)setupViewControllers
{
    UIColor *textColor = BottomColor;
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setTitle:@"首页"];
    [item1 setImage:[UIImage imageNamed:@"home"]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"home_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setTitle:@"发起项目"];
    [item2 setImage:[UIImage imageNamed:@"wei"]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"wei_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item3 = [[UITabBarItem alloc] init];
    item3.tag = 3;
    [item3 setTitle:@"圈子"];
    [item3 setImage:[UIImage imageNamed:@"ellipse"]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"ellipse_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.tag = 4;
    [item4 setTitle:@"我的"];
    [item4 setImage:[UIImage imageNamed:@"wo"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"wo_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    _homeVC = [[McjHomeViewController alloc] init];
    _homeVC.tabBarItem = item1;
    
    StartFirstProjectViewController *weiPublicFundViewController = [[StartFirstProjectViewController alloc] init];
    weiPublicFundViewController.tabBarItem = item2;
    
    _circelViewController = [[ConversationListController alloc] init];
    [_circelViewController networkChanged:_connectionState];
    _circelViewController.tabBarItem = item3;
    
    MyCenterViewController *myController = [[MyCenterViewController alloc] init];
    myController.tabBarItem = item4;
    
    self.viewControllers =@[_homeVC,weiPublicFundViewController,_circelViewController,myController];
    self.delegate = self;
    self.selectedIndex = 0;
}

+ (void)setAppearanceNaviBar
{
    [[UINavigationBar appearance] setBarTintColor:NaviColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
}

- (void)updateUserInfo
{
    // user 更新
    User *user = [User userFromFile];
    User *defaultUser = [User shareUser];
    if (user != nil && [user.Id intValue] != 0)
    {
        defaultUser.Id = user.Id;
        defaultUser.avatar = user.avatar;
        defaultUser.password = user.password;
        defaultUser.nickName = user.nickName;
        defaultUser.userName = user.userName;
        defaultUser.mobile = user.mobile;
        defaultUser.isOtherLogin = user.isOtherLogin;
        defaultUser.otherLoginResult = user.otherLoginResult;
        defaultUser.realName = user.realName;
    }
}

- (void)autoLogin
{
    User *defaultUser = [User shareUser];
    if ([defaultUser.Id intValue] != 0)
    {
        //自动登录
        [self hxLoginWithUsername:defaultUser.userName password:defaultUser.password];
    }
}

- (void)updatePhoneContact
{

    User *userInfo = [User shareUser];
    if (userInfo.Id.integerValue != 0)
    {
        RequestAddressUtil *util = [RequestAddressUtil shareRequestAddressUtil];
        if (util.updateStatus == RequestAddressStatusUpdating || util.updateStatus == RequestAddressStatusUpdated)
        {
            return;
        }
        [util updateAddressBookComplete:^(int status, NSError *error, NSString *msg,id data) {
            NSLog(@"%@",msg);
        }];
    }
}

- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *unReadConversations = [NSMutableArray arrayWithCapacity:conversations.count];
    NSInteger unreadTotalCount = 0;
    NSInteger unreadApplyCount = [ApplyViewController shareController].unReadCount;
    unreadTotalCount += unreadApplyCount;
    
    for (EMConversation *conversation in conversations) {
        NSInteger unreadCount = conversation.unreadMessagesCount;
        unreadTotalCount += unreadCount;
        if (unreadCount)
        {
            [unReadConversations addObject:conversation];
        }
    }
    
    if (_circelViewController)
    {
        if (unreadTotalCount > 0)
        {
            _circelViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",(NSInteger)unreadTotalCount];
            _circelViewController.untreatedApplyCount = [NSString stringWithFormat:@"%zd",unreadApplyCount];
        }
        else
        {
            _circelViewController.untreatedApplyCount = @"0";
            _circelViewController.tabBarItem.badgeValue = nil;
        }
    }
    
//    if (_homeVC)
//    {
//        _homeVC.conversations = unReadConversations;
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadTotalCount];
}

- (void)setupUntreatedApplyCount
{
    [self setupUnreadMessageCount];
//    NSInteger unreadCount = [ApplyViewController shareController].unReadCount;
//    NSInteger unreadTotalCount = 0;
//    
//    if (_circelViewController)
//    {
//        if (unreadCount > 0)
//        {
//            _circelViewController.untreatedApplyCount = [NSString stringWithFormat:@"%zd",(NSInteger)unreadCount];
//            unreadTotalCount = [_circelViewController.tabBarItem.badgeValue integerValue];
//            unreadTotalCount += unreadCount;
//            _circelViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",(int)unreadTotalCount];
//        }
//        else
//        {
//            _circelViewController.untreatedApplyCount = nil;
//        }
//    }
//    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadTotalCount];
}

#pragma mark - Notification
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_circelViewController networkChanged:connectionState];
}

- (void)loginStateChange:(NSNotification *)notification
{
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        // 跳到登录页面
        [self setupUnreadMessageCount];
        [self setupUntreatedApplyCount];
    } onQueue:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.selectedIndex = 0;
    self.navigationItem.title = @"首页";
    LoginViewController * login = [[LoginViewController alloc] init];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
    //    NSLog(@"%@",self.navigationController);
    [self.navigationController presentViewController:navi animated:NO completion:nil];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    User *userInfo = [User shareUser];
    if (userInfo == nil || [userInfo.Id intValue] == 0)
    {
        if ([viewController isKindOfClass:[StartFirstProjectViewController class]] || [viewController isKindOfClass:[ConversationListController class]] || [viewController isKindOfClass:[MyCenterViewController class]])
        {
            LoginViewController * login = [[LoginViewController alloc] init];
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
            [self.selectedViewController presentViewController:navi animated:YES completion:nil];
            return NO;
        }
    }else{
        if ([viewController isKindOfClass:[StartFirstProjectViewController class]])
        {
            NSLog(@"------%d",_ok);
            if ([self userStat]) {
                return YES;
                _ok = NO;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)userStat
{
    [MBProgressHUD showStatus:nil toView:self.view];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"Personal/Setting" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            if (IsStrEmpty([dic objectForKey:@"IdNumber"]) && IsStrEmpty([dic objectForKey:@"Mobile"])){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要实名认证，且绑定手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
                alert.tag = 40000;
                [alert show];
                _ok = NO;
            }else if (IsStrEmpty([dic objectForKey:@"IdNumber"])){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要实名认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
                alert.tag = 20000;
                [alert show];
                _ok = NO;
            }else if (IsStrEmpty([dic objectForKey:@"Mobile"])) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要绑定手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
                alert.tag = 10000;
                [alert show];
                _ok = NO;
            }else if([[dic objectForKey:@"IsAbleCreateCF"] integerValue] == 1){
                [MBProgressHUD showMessag:@"你有项目在筹资中，等成功后再来哦" toView:self.view];
                _ok = NO;
            }else if([[dic objectForKey:@"IsAbleCreateCF"] integerValue] == 0){
                [MBProgressHUD showMessag:@"您已被加入黑名单，不能发布项目" toView:self.view];
                _ok = NO;
            }else{
                _ok = YES;
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
            _ok = NO;
        }
    }];
    return _ok;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 0:
            self.navigationItem.title = @"首页";
            break;
        case 1:
            self.navigationItem.title = @"发起项目";
            break;
        case 2:
            self.navigationItem.title = @"圈子";
            break;
        case 3:
            self.navigationItem.title = @"个人中心";
            break;
        default:
            self.navigationItem.title = @"首页";
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error)
            {
                [self loginStateChange:nil];
                
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100 || alertView.tag == 101) {
        //您的帐号在其他的地方登录，是否登录
            [self loginStateChange:nil];
    }else if (alertView.tag == 102 || alertView.tag == 103)
    {
        if (buttonIndex)
        {
            [self loginStateChange:nil];
        }
    }else if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            IphoneBindingViewController *iphoneBindingVC = [[IphoneBindingViewController alloc] init];
            [self.navigationController pushViewController:iphoneBindingVC animated:YES];
        }
    }else if (alertView.tag == 20000 || alertView.tag == 40000){
        if (buttonIndex == 1) {
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
    }
}

#pragma mark - IChatManagerDelegate 消息变化
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_circelViewController refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

// 记录 解析透传消息
-(void)didReceiveCmdMessage:(EMMessage *)message
{
    EMCommandMessageBody *body = (EMCommandMessageBody *)message.messageBodies.lastObject;
    PSChat *chat = [ChatBuddyDAO chatBuddyWithUserame:message.from];
    NSLog(@"action = %@",body.action);
    if ([body.action isEqualToString:@"ChangeAvatar"])
    {
        NSLog(@"message.ext = %@",message.ext);
        // cmd消息中的扩展属性
        NSString *avatar = [message.ext objectForKey:@"CMDVAL"];
        chat.avatar = avatar;
        [ChatBuddyDAO updateChatBuddy:chat];
    }
    else if ([body.action isEqualToString:@"ChangeName"])
    {
        NSString *name =[message.ext objectForKey:@"CMDVAL"];
        chat.showName = name;
        [ChatBuddyDAO updateChatBuddy:chat];
    }
}

// 离线透传消息
- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    for (EMMessage *message in offlineCmdMessages)
    {
        // 透传删除（针对离线被好友删除操作）
        EMCommandMessageBody *body = (EMCommandMessageBody *)message.messageBodies.lastObject;
        if ([body.action isEqualToString:@"DeleteFriend"])
        {
            NSString *username = [message.ext objectForKey:@"CMDVAL"];
            [self didRemovedByBuddy:username];
//            // 删除回话
//            [self _removeBuddies:@[username]];
//            // 删除 apply
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
//            [InvitationManager removeInvitationBuddyName:username loginUser:loginUsername];
            
//            [self _removeBuddies:@[username]];
//            //    [ChatFriendDAO deletChatFriendWithUsername:username];
//            // 删除 apply
//            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
//            [InvitationManager removeInvitationBuddyName:username loginUser:loginUsername];
            
            continue;
        }
        [self didReceiveCmdMessage:message];
    }
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

#pragma mark - 显示通知
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"图片";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"位置";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"音频";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"视频";
            }
                break;
            default:
                break;
        }
        
        NSString *title = [ChatBuddyDAO chatBuddyWithUserame:message.from].showName;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
//#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
//    notification.alertBody = [[NSString alloc] initWithFormat:@"%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_circelViewController isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:@"%@ 添加你为好友", username];
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
//#warning TODO contacts 刷新
//    [_contactsVC reloadApplyView];
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_circelViewController refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController conversation].chatter])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [self.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
}

//通讯录信息发生变化时的通知
- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    if (!isAdd)// 删除好友
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            if ([buddy.username length])
            {
                [deletedBuddies addObject:buddy.username];
                
                // 删除 apply
                NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
                [InvitationManager removeInvitationBuddyName:buddy.username loginUser:loginUsername];
            }
        }
        if (![deletedBuddies count])
        {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
//        [ChatFriendDAO deleteChatFriends:deletedBuddies];
    }
    else// 添加好友
    {
        // clear conversation
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *deleteConversations = [NSMutableArray arrayWithArray:conversations];
        NSMutableDictionary *buddyDic = [NSMutableDictionary dictionary];
        for (EMBuddy *buddy in buddyList) {
            if ([buddy.username length]) {
                [buddyDic setObject:buddy forKey:buddy.username];
            }
        }
        for (EMConversation *conversation in conversations) {
            if (conversation.conversationType == eConversationTypeChat)
            {
                if ([buddyDic objectForKey:conversation.chatter])
                {
                    [deleteConversations removeObject:conversation];
                }
            }
            else
            {
                [deleteConversations removeObject:conversation];
            }
        }
        if ([deleteConversations count] > 0)
        {
            NSMutableArray *deletedBuddies = [NSMutableArray array];
            
            if ([deletedBuddies count] > 0)
            {
                [self _removeBuddies:deletedBuddies];
            }
        }
    }
    
//    // 更新数据库
//    NSMutableString *usernames = [NSMutableString string];
//    for (EMBuddy *buddy in changedBuddies)
//    {
//        NSString *username = buddy.username;
//        if (![ChatFriendDAO existChatFriendWithUsername:username])
//        {
//            // 需要添加
//            [usernames appendFormat:@",%@",username];
//        }
//    }
//    if (usernames.length > 0)
//    {
//        [usernames deleteCharactersInRange:NSMakeRange(0, 1)];
//        [self requestNewFriendsWithUsernames:usernames];
//    }
}

//登录的用户被好友从列表中删除了
- (void)didRemovedByBuddy:(NSString *)username
{
    [self _removeBuddies:@[username]];
//    [ChatFriendDAO deletChatFriendWithUsername:username];
    // 删除 apply
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    [InvitationManager removeInvitationBuddyName:username loginUser:loginUsername];
}

//好友请求被接受时的回调
- (void)didAcceptedByBuddy:(NSString *)username
{
    // 添加好友
//    if (![ChatFriendDAO existChatFriendWithUsername:username])
//    {
//        // 需要添加 请求
//        [self requestNewFriendsWithUsernames:username];
//    }
}

//好友请求被拒绝时的回调
- (void)didRejectedByBuddy:(NSString *)username
{
    [self requestLoadSystemNotificationMessage:[NSString stringWithFormat:@"'%@'拒绝了你的好友请求",username]];
}

#pragma mark - Request
- (void)requestLoadSystemNotificationMessage:(NSString *)message
{
    NetWorkingUtil *httpUtil = [NetWorkingUtil netWorkingUtil];
    [httpUtil requestDic4MethodName:@"DynaMsg/AddMsg" parameters:@{@"Message":message} result:^(NSDictionary *dic, int status, NSString *msg) {}];
}


//- (void)requestNewFriendsWithUsernames:(NSString *)usernames
//{
//    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/InfoList" parameters:@{@"UserNameList":usernames} result:^(NSArray *arr, int status, NSString *msg)
//     {
//         if (status == 1 && arr.count)
//         {
//             [ChatFriendDAO updateChatFriends:arr];
//         }
//     } convertClassName:@"PSBuddy" key:@"listinfo"];
//}

#pragma mark - IChatManagerDelegate 群组变化
- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_circelViewController reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
        [_circelViewController reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    [self requestLoadSystemNotificationMessage:[NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username]];
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
//    NSString *message = [NSString stringWithFormat:@"同意并已加入群组\'%@\'", groupname];
//    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该账户已在其他设备登录，若不是您本人操作，请尽快更换密码！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号已被从服务器端移除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [self loginStateChange:nil];
}

- (void)didAppkeyChanged
{
    [self loginStateChange:nil];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:@"正在重连中..."];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:@"重连失败，稍候将继续重连"];
        }else{
            [self showHint:@"重连成功！"];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {

    }
    else if(_circelViewController)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_circelViewController];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {

        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_circelViewController)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_circelViewController];
    }
}

@end
