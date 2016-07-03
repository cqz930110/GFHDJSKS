//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.minShowTime = .3;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    [hud hide:YES afterDelay:1.5];
}

#pragma mark 显示一些信息
+ (void)showMessag:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = .3;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1.5秒之后再消失
    [hud hide:YES afterDelay:delay];
}

+ (void)showMessag:(NSString *)message toView:(UIView *)view
{
    [self showMessag:message toView:view hideAfterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showMessag:error toView:view hideAfterDelay:2.5];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self showMessag:success toView:view];
}

+ (MB_INSTANCETYPE)showStatus:(NSString *)status toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.minShowTime = .3;
    hud.detailsLabelText = status;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0];
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

+ (BOOL)dismissHUDForView:(UIView *)view {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        return YES;
    }
    return NO;
}

+ (BOOL)dismissHUDForView:(UIView *)view withMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil)
    {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        [hud hide:YES afterDelay:delay];
        return YES;
    }
    [MBProgressHUD showMessag:message toView:view hideAfterDelay:delay];
    return NO;
}

+ (BOOL)dismissHUDForView:(UIView *)view withError:(NSString *)error {
    return [self dismissHUDForView:view withMessage:error hideAfterDelay:2.5];
}

+ (BOOL)dismissHUDForView:(UIView *)view withSuccess:(NSString *)success {
    return [self dismissHUDForView:view withMessage:success hideAfterDelay:1.5];
}

//+ (BOOL)dismissHUDForView:(UIView *)view withError:(NSString *)error {
//    MBProgressHUD *hud = [self HUDForView:view];
//    if (hud != nil) {
//        hud.labelText = error;
//        // 设置图片
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
//        // 再设置模式
//        hud.mode = MBProgressHUDModeCustomView;
//        
//        // 隐藏时候从父控件中移除
//        hud.removeFromSuperViewOnHide = YES;
//        
//        // 1.0秒之后再消失
//        [hud hide:YES afterDelay:1.0];
//        return YES;
//    }
//    return NO;
//}
//
//+ (BOOL)dismissHUDForView:(UIView *)view withsuccess:(NSString *)success {
//    MBProgressHUD *hud = [self HUDForView:view];
//    if (hud != nil) {
//        hud.labelText = success;
//        // 设置图片
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
//        // 再设置模式
//        hud.mode = MBProgressHUDModeCustomView;
//        
//        // 隐藏时候从父控件中移除
//        hud.removeFromSuperViewOnHide = YES;
//        
//        // 1.0秒之后再消失
//        [hud hide:YES afterDelay:1.0];
//        return YES;
//    }
//    return NO;
//}

// custem
//+ (MB_INSTANCETYPE)mb_ProgressHUDStatusToView:(UIView*)view statusString:(NSString*)statusString
//{
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD* hud = [[self alloc] initWithView:view];;
//    //    hud.animationType = MBProgressHUDAnimationZoom;
//    hud.removeFromSuperViewOnHide = YES;
//    hud.minShowTime = .5;
//    hud.labelText = statusString;
//    [view addSubview:hud];
//    [hud show:YES];
//    return hud;
//}

//
//- (void)dismissErrorStatusString:(NSString*)statusString hideAfterDelay:(NSTimeInterval)delay
//{
//    self.labelText = statusString;
//    // 设置图片
//    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
//    // 再设置模式
//    self.mode = MBProgressHUDModeCustomView;
//    [self hide:YES afterDelay:delay];
//}
//
//- (void)dismissSuccessStatusString:(NSString *)statusString hideAfterDelay:(NSTimeInterval)delay
//{
//    self.labelText = statusString;
//    // 设置图片
//    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
//    // 再设置模式
//    self.mode = MBProgressHUDModeCustomView;
//    [self hide:YES afterDelay:delay];
//}

@end
