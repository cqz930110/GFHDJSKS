//
//  RechargeViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/29.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,RechargeType)
{
    RechargeTypeJDPay,
    RechargeTypeWeixin
//    RechargeTypeAlipay
};
@interface RechargedViewController : BaseViewController
@property (assign, nonatomic) BOOL haveBankCard;
@end
