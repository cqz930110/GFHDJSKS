//
//  PSBuddy.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/16.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSBuddy : NSObject
/// 好友关系Id
@property (assign, nonatomic) long Id;
/// 好友的用户Id
@property (assign, nonatomic) long userId;
/// 昵称
@property (copy, nonatomic) NSString *nickName;
/// 图像
@property (copy, nonatomic) NSString *avatar;

/// 环信用户名
@property (copy, nonatomic) NSString *userName;

/// 环信用户名
@property (copy, nonatomic) NSString *notes;

/// 真实名
@property (copy, nonatomic) NSString *realName;

@property (copy, nonatomic) NSString *districtName;

//个性描述
@property (copy, nonatomic) NSString *signature;
//关系ID
@property (copy, nonatomic) NSString *firendShipId;
@property (nonatomic,assign)int isFriend;

- (NSString *)reviewName;

+ (PSBuddy *)sharePSBuddy;

/// 扩展属性（用于 database）
@property (strong, nonatomic) NSDictionary *userInfo;
@end