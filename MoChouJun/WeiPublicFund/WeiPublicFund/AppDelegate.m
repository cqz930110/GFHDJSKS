//
//  AppDelegate.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/11/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <IQKeyboardManager.h>
#import "AppDelegate+EaseMob.h"

#import "NetWorkingUtil.h"
#import "JSONKit.h"
#import "Contact.h"
#import "ShareUtil.h"
#import "PayUtil.h"
#import "AddressCoreDataManage.h"

#import <WebKit/WebKit.h>
#import "NdUncaughtExceptionHandler.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // 创建数据库
    [AddressCoreDataManage shareAddressCoreDataManage];

    //IQKeyboardManager
    [self IQKeyboardManagerSetting];
    
    //分享
    [ShareUtil shareSetting];
    
    // JPush
    [self JPushSettingLaunchOptions:launchOptions];
    
//#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
//#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"aps_development";
#else
    apnsCertName = @"aps_production";
#endif
    
     NSString *appkey;
    if (IsLoadBundle)
    {
        appkey = @"ndz#weipublicfund";
    }
    else
    {
        appkey = @"ndz#mochoujuntest";
    }
   
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
//    [NdUncaughtExceptionHandler setDefaultHandler];
    
//    @[][0];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"" forKey:@"updateContactBug"];
//    [userDefaults synchronize];
    return YES;
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController)
    {
        [_mainController jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 接受到本地推送的操作
    if (_mainController)
    {
        [_mainController didReceiveLocalNotification:notification];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url.host);
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//        return YES;
//    }
//    
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
//        
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//        return YES;
//    }

    if ([url.host  isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:[PayUtil payUtil]];
    }
    
    return [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - JPushSetting
- (void)JPushSettingLaunchOptions:(NSDictionary *)launchOptions
{
    // JPush
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                        UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    NSString *appKey;
    BOOL isProduction;
    if (IsLoadBundle) {
        appKey = @"7c32f1f5445fc2a108ccd5ee";
        isProduction = YES;
    }
    else
    {
        appKey = @"62d9b2533b58da593086355e";
        isProduction = NO;
    }
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"App Store" apsForProduction:isProduction];
    [JPUSHService setLogOFF];
}

#pragma mark - IQKeyboardManagerSetting
- (void)IQKeyboardManagerSetting
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}

@end
