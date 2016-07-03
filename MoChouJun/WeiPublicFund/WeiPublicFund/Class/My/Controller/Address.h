//
//  Address.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/11/2.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

/// 地址Id
@property (assign, nonatomic) NSInteger Id;
/// 收货人姓名
@property (copy, nonatomic) NSString *recvName;
/// 手机号
@property (copy, nonatomic) NSString *mobile;
/// 省市区地址
@property (copy, nonatomic) NSString *address;
/// 地址详情
@property (copy, nonatomic) NSString *details;

/// 邮政编码
@property (nonatomic,strong)NSString *zipCode;
/// 是否为默认收货地址  1不是   2是
@property (assign, nonatomic) NSInteger statusId;

// 地区ID
@property (assign, nonatomic) NSInteger districtId;
@end
