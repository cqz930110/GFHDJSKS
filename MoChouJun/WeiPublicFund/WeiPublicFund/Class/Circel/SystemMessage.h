//
//  SystemMessage.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/18.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessage : NSObject
/// 自增主键
@property (assign, nonatomic) int Id;

/// 消息接受人
@property (assign, nonatomic) int userId;

/// 消息关联ID   可能是众筹项目Id
@property (assign, nonatomic) int aboutId;

/// 信息内容
@property (copy, nonatomic) NSString  *message;
/// 创建时间
@property (copy, nonatomic) NSString *createDate;
@end
