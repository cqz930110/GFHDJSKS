//
//  PayUtil.h
//  WaiMai
//
//  Created by vi_chen on 15-2-14.
//  Copyright (c) 2015年 yunna. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayUtil;
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import "LLPaySdk.h"
@interface PayUtil : NSObject<WXApiDelegate>//LLPaySdkDelegate
typedef NS_ENUM(NSInteger, BankPayType) {
    BankPayTypeAliPay, //支付宝
    BankPayTypeWeixinPay,// 微信
    BankPayTypeJDPay
};

+ (PayUtil *)payUtil;
-(void)payWithType:(BankPayType)payType viewController:(UIViewController*)viewController param:(id)param completion:(void (^)(BOOL isSuccess))completion;
-(void)payResult:(BOOL)isSuccess;
@end
