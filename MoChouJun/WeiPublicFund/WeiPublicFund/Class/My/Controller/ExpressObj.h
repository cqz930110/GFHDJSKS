//
//  ExpressObj.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressObj : NSObject

/// 支持Id
@property (nonatomic,assign)int supportProjectId;
/// 回报ID
@property (nonatomic,assign)int repayId;
/// 回报内容
@property (nonatomic,strong)NSString *Description;
/// 收货人
@property (nonatomic,strong)NSString *recvName;
/// 地址
@property (nonatomic,strong)NSString *addressInfo;
/// 支持数量
@property (nonatomic,assign)int count;
/// 实际支付金额
@property (nonatomic,strong)NSString *amount;
/// 发起人设置的需要支持的金额
@property (nonatomic,strong)NSString *supportAmount;
/// 手机
@property (nonatomic,strong)NSString *mobile;
/// 快递公司Id
@property (nonatomic,assign)NSInteger expressId;
/// 快递公司名称
@property (nonatomic,strong)NSString *expressName;
/// 是否需要快递 0不需要 1需要
@property (nonatomic,assign)int isExpressed;
/// 快递单号
@property (nonatomic,strong)NSString *expressNo;
/// 创建时间
@property (nonatomic,strong)NSString *createDate;
/// 1有偿回报需要收货地址 2有偿回报无需收货地址 3无偿回报
@property (nonatomic,assign)NSInteger typeId;
@end
