//
//  ShareUtil.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/23.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
typedef void(^Callback)(NSDictionary *result);
@interface ShareUtil : NSObject
/// 配置方法 UIApplication
+ (void)shareSetting;

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
+ (void)postShareWithShareType:(NSString *)shareType title:(NSString*)title content:(NSString *)content urlResource:(NSString *)urlResource clickPushUrl:(NSString*)pushUrl presentedController:(UIViewController*)presentedController completion:(UMSocialDataServiceCompletion)completion;

/**
 *  三方登录
 *
 *  @param loginType 三方登录类型 ：微博 UMShareToSina QQ UMShareToQQ 微信 UMShareToWechatSession
 *  @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 *  @return userInfo  用户信息
 */
+ (void)umengOtherLoginWithLoginType:(NSString *)loginType presentingController:(UIViewController *)presentingController callback:(Callback)result;

/**
 *  判断是否用户是否安装了对应的三方应用
 *
 *  @param shareType 三方类型 分享到的平台 例如`新浪微博：UMShareToSina`，`QQ空间：UMShareToQzone`微信朋友圈：UMShareToWechatTimeline、 微信好友：UMShareToWechatSession ， 手机QQ：UMShareToQQ。
 */
+ (BOOL)hideButtonWithThreeType:(NSString *)shareType;

+ (NSArray *)showInstalledThreeButtons;
@end
