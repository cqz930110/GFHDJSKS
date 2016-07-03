//
//  BankCard.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/2/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : NSObject
/// BankTypeId
@property (assign, nonatomic) int bankTypeId;
/// 银行卡对应的账户Id
@property (assign, nonatomic) int userAccountId;
/// DistrictId
@property (assign, nonatomic) int districtId;
/// 卡号
@property (copy, nonatomic) NSString *accountNum;
/// 银行名称
@property (copy, nonatomic) NSString *bankName;
@property (copy, nonatomic) NSString *district;
/// 开户行(支行)
@property (copy, nonatomic) NSString *branchName;
/// 银行Logo
@property (copy, nonatomic) NSString *bankIconUrl;

//  状态
@property (nonatomic,assign)int statusId;

/// 卡号 转换后
@property (copy, nonatomic) NSString *transformAccountNum;
@end
