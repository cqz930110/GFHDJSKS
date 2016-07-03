//
//  Project.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/7.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Project : NSObject
/// 项目Id
@property (assign, nonatomic) int Id;
@property (assign, nonatomic) int crowdFundId;

/// 众筹名称
@property (copy, nonatomic) NSString *name;

/// 图片地址，多张图片逗号分割
@property (copy, nonatomic) NSArray *images;

/// 期限,单位：天
@property (assign, nonatomic) int remainDays;

/// 创建日期
@property (copy, nonatomic) NSString *createDate;

/// 项目发布人的昵称
@property (copy, nonatomic) NSString *nickName;

/// 项目发布人的图像
@property (copy, nonatomic) NSString *avatar;

/// 该项目被支持的人数
@property (assign, nonatomic) int supportedCount;
@property (assign, nonatomic) int supportCount;

/// 被评论人数
@property (assign, nonatomic) int commentedCount;

/// 目标金额
@property (strong,nonatomic)NSString *targetAmount;

/// 已筹金额
@property (strong,nonatomic)NSString *raisedAmount;

///  简介
@property (nonatomic,strong)NSString *profile;

@property (nonatomic,strong)NSString *userName;

//   项目剩余天数，状态
@property (nonatomic,strong)NSString *showStatus;

@property (nonatomic, assign)int userId;

@property (nonatomic,assign)int statusId;


@end
