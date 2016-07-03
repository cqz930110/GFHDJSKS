//
//  SupportedProject.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/10.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportedProject : NSObject
//"Id":2,"UserId":0,"UserNickname":null,"UserAvatar":null,"ProjectName":"我要上太空","RepayId":2,"Description":"简介简123介简介","Amount":963.0000,"ProjectStatusId":0,"UserAddresId":2,"Details":"江西省九江市九江县商城路618号良友大厦15楼"}
@property (assign, nonatomic) int Id;
/// 支持者
@property (assign, nonatomic) int userId;
/// 项目ID
@property (assign, nonatomic) int crowdFundId;
/// 回报ID
@property (assign, nonatomic) int repayId;

/// 投资金额
@property (assign, nonatomic) double amount;

///   0待回报   1回报中  2已回报 3已失败
@property (assign, nonatomic) short statusId;
/// 用户地址Id
@property (assign, nonatomic) int userAddresId;
/// 创建时间
@property (copy, nonatomic) NSString *createDate;

/// 支持人员昵称
@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *userNickname;
/// 支持人员图像
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *userAvatar;
/// 项目名称
@property (copy, nonatomic) NSString *name;

/// 项目状态
@property (copy, nonatomic) NSString *showStatus;

/// 回报内容简介
@property (copy, nonatomic) NSString *profile;

/// 地址详情
@property (copy, nonatomic) NSString *details;

/// 项目图片
@property (nonatomic,strong)NSString *images;

/// 剩余时间
@property (nonatomic,assign)NSInteger dueDays;

/// 收件人
@property (copy, nonatomic) NSString *recvName;

@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *description;

@property (nonatomic,strong)NSString *mobile;

///   三期添加

///  回报内容
@property (nonatomic,strong)NSString *content;

///  已筹金额
@property (nonatomic,strong)NSString *raisedAmount;

///  目标金额
@property (nonatomic,strong)NSString *targetAmount;

///  已支持人数
@property (nonatomic,assign)NSInteger supportCount;

///  快递数量
@property (nonatomic,assign)NSInteger expressCount;

///  剩余时间
@property (nonatomic,strong)NSString *remainTime;

///  隐藏按钮
@property (nonatomic,assign) NSInteger repayCount;


@end
