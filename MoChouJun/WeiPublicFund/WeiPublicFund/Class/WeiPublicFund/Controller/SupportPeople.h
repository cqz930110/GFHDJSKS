//
//  SupportPeople.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/9.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportPeople : NSObject
/// 支持人员昵称
@property (copy, nonatomic) NSString *userNickname;
/// 支持人员图像
@property (copy, nonatomic) NSString *userAvatar;
/// 投资金额
@property (assign, nonatomic) double amount;
@property (assign, nonatomic) int Id;
/// 支持者
@property (assign, nonatomic) int userId;

/// 项目ID
@property (assign, nonatomic) int crowdFundId;

/// 回报ID
@property (assign, nonatomic) int repayId;

/// 创建时间
@property (copy, nonatomic) NSString *createDate;

@property (nonatomic,strong)NSString *userName;
@end
