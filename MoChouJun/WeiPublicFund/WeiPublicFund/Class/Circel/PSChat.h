//
//  PSChat.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSChat : NSObject

/// 头像
@property (copy, nonatomic) NSString *avatar;
/// 好友用户Id或者群Id
/// 类型  0好友Id   1环信生成的群Id
@property (assign, nonatomic) long type;

@property (copy, nonatomic) NSString *nikeName;// 请使用下面name,name包括群名称
/// 好友昵称或者群名称
@property (copy, nonatomic) NSString *name;
/// 备注用户民
@property (copy, nonatomic) NSString *notes;
// 显示的昵称
@property (copy, nonatomic) NSString *showName;//最终显示的昵称

/// 环信用户名
@property (copy, nonatomic) NSString *userName;// 使用下面value，value包括群Id
/// 好友用户名或者环信生成的群Id 以value为主，value包括群Id
@property (copy, nonatomic) NSString *value;

///  区分群和好友、讨论组
@property (nonatomic,assign) int showType;

/// 是否删除会话
@property (assign, nonatomic) BOOL isDelete;
/// 扩展属性（用于 database）
@property (strong, nonatomic) NSDictionary *userInfo;
@end
