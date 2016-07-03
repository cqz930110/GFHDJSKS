//
//  ShareUtil.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/23.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ShareUtil.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "YYModel.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "MobClick.h"

@implementation ShareUtil
+ (void)shareSetting
{
    // 线上线下判断
    if (IsLoadBundle)
    {
        // 友盟统计
        [MobClick startWithAppkey:@"5698bbf6e0f55a43430024c5" reportPolicy:BATCH   channelId:nil];
        
        //设置友盟社会化组件appkey
        [UMSocialData setAppKey:@"5698bbf6e0f55a43430024c5"];
        
        //默认为App Store
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:@"wx96399aa44a3ea84b" appSecret:@"3938a1f33219ff6662f04263952505fc" url:nil];//@"http://www.pgyer.com/pLBN"
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        [UMSocialQQHandler setQQWithAppId:@"1105026828" appKey:@"l7Onf42ejIT8M1Yc" url:nil];
        //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2817270884" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    }
    else
    {
        //友盟统计
        [MobClick startWithAppkey:@"567a0ddb67e58ef9db00077d" reportPolicy:BATCH   channelId:nil];//nil
        //设置友盟社会化组件appkey
        [UMSocialData setAppKey:@"567a0ddb67e58ef9db00077d"];
      
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:@"wx96399aa44a3ea84b" appSecret:@"3938a1f33219ff6662f04263952505fc" url:nil];
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        [UMSocialQQHandler setQQWithAppId:@"1105026828" appKey:@"l7Onf42ejIT8M1Yc" url:nil];
        //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2817270884" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    }
}
//+ (void)shareSetting
//{
//    //设置友盟社会化组件appkey
//    [UMSocialData setAppKey:@"567a0ddb67e58ef9db00077d"];
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:@"wx96399aa44a3ea84b" appSecret:@"3938a1f33219ff6662f04263952505fc" url:@"http://www.pgyer.com/pLBN"];
//    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
//    [UMSocialQQHandler setQQWithAppId:@"1105026828" appKey:@"l7Onf42ejIT8M1Yc" url:@"http://www.pgyer.com/pLBN"];
//    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2817270884" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
////    [WXApi registerApp:<#(NSString *)#> withDescription:<#(NSString *)#>]
//}

/**
 分享
 @param shareType    分享到的平台 例如`新浪微博：UMShareToSina`，`QQ空间：UMShareToQzone`微信朋友圈：UMShareToWechatTimeline、 微信好友：UMShareToWechatSession ， 手机QQ：UMShareToQQ。
 @param title            分享的标题
 @param content          分享的文字内容
 @param pushUrl          点击分享跳转的Url
 @param urlResource      分享的 图片、音乐、视频等url资源
 @param completion       发送完成执行的block对象
 @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 
 */
+ (void)postShareWithShareType:(NSString *)shareType title:(NSString*)title content:(NSString *)content urlResource:(NSString *)urlResource clickPushUrl:(NSString*)pushUrl presentedController:(UIViewController*)presentedController completion:(UMSocialDataServiceCompletion)completion{
    UMSocialUrlResource *utlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:urlResource];
    if ([shareType isEqualToString:UMShareToSina])
    {
        content = [NSString stringWithFormat:@"%@-->%@",title,pushUrl];
    }
    else if ([shareType isEqualToString:UMShareToQzone])
    {
        [UMSocialData defaultData].extConfig.qzoneData.url = pushUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
    }
    else if ([shareType isEqualToString:UMShareToQQ])
    {
        [UMSocialData defaultData].extConfig.qqData.url = pushUrl;
        [UMSocialData defaultData].extConfig.qqData.title = title;
    }
    else if ([shareType isEqualToString:UMShareToWechatTimeline])
    {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = pushUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    }
    else if ([shareType isEqualToString:UMShareToWechatSession])
    {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = pushUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    }
    //自定义分享
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:content image:nil location:nil urlResource:utlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
        if (completion)
        {
            completion(response);
        }else{
            NSLog(@"-----%@",response);
        }
    }];
}

/**
 *  三方登录
 *
 *  @param loginType 三方登录类型 ：微博 UMShareToSina QQ UMShareToQQ 微信 UMShareToWechatSession
 *  @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 *  @return userInfo  用户信息
 */
+ (void)umengOtherLoginWithLoginType:(NSString *)loginType presentingController:(UIViewController *)presentingController callback:(Callback)result
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:loginType];
    snsPlatform.loginClickHandler(presentingController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:loginType];
            NSLog(@"==========snsAccount = %@ response = %@",snsAccount,response);
            //platformName  usid  iconURL userName
            NSMutableDictionary *results = [NSMutableDictionary dictionary];
            NSString *otherType;
            if ([loginType isEqualToString:UMShareToSina]) {
                otherType = @"0";
            }
            else if ([loginType isEqualToString:UMShareToQQ])
            {
                otherType = @"2";
            }
            else if ([loginType isEqualToString:UMShareToWechatSession])
            {
                otherType = @"1";
            }
            [results setValue:otherType forKey:@"Type"];
            [results setValue:snsAccount.usid forKey:@"OpenId"];
            [results setValue:snsAccount.userName forKey:@"NickName"];
            [results setValue:snsAccount.iconURL forKey:@"Avatar"];
            [results setValue:snsAccount.accessToken forKey:@"UnionId"];
            result(results);
        }
        else
        {
            result(nil);
        }
    });
}

+ (BOOL)hideButtonWithThreeType:(NSString *)shareType
{
    //三方类型
    if ([shareType isEqualToString:UMShareToSina])// 新浪微博
    {
        return !([WeiboSDK isWeiboAppInstalled]);
    }
    else if ([shareType isEqualToString:UMShareToQzone])// QQzone
    {
        return !([QQApiInterface isQQInstalled]);
    }
    else if ([shareType isEqualToString:UMShareToQQ])// QQ
    {
        return !([QQApiInterface isQQInstalled]);
    }
    else if ([shareType isEqualToString:UMShareToWechatTimeline])// 微信朋友圈
    {
        return !([WXApi isWXAppInstalled]);
    }
    else if ([shareType isEqualToString:UMShareToWechatSession])//微信好友
    {
        return !([WXApi isWXAppInstalled]);
    }
    
    return YES;
}

/**
 *  目前只支持 QQ WeiChat Sina
 *
 *  @return 返回 已经安装了的三方类型
 */
+ (NSArray *)showInstalledThreeButtons
{
    BOOL isHideSina =[ShareUtil hideButtonWithThreeType:UMShareToSina];
    BOOL isHideWeiXin = [ShareUtil hideButtonWithThreeType:UMShareToWechatSession];
    BOOL isHideQQ = [ShareUtil hideButtonWithThreeType:UMShareToQQ];
    
    NSMutableArray *installThreeTypes = [NSMutableArray arrayWithCapacity:2];
//    
    if (!isHideSina)
    {
    [installThreeTypes addObject:UMShareToSina];
    }
    
    if (!isHideQQ)
    {
        [installThreeTypes addObject:UMShareToQQ];
    }

    if (!isHideWeiXin)
    {
        [installThreeTypes addObject:UMShareToWechatSession];
    }

    return installThreeTypes;
}
@end
