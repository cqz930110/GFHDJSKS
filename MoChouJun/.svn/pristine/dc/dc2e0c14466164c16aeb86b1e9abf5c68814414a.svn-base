//
//  User.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/27.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户是否登录过
#define KHaveLogin    @"KHaveLogin"
@interface User : NSObject<NSCoding>
/// 手机号
@property (copy, nonatomic) NSString *mobile;

/// 用户名
@property (copy, nonatomic) NSString *userName;

/// 昵称
@property (copy, nonatomic) NSString *nickName;

/// 密码
@property (copy, nonatomic) NSString *password;

/// 用户编号
@property (copy, nonatomic) NSNumber *Id;

/// 用户头像
@property (nonatomic,strong) NSString *avatar;

/// 真实姓名
@property (nonatomic,strong) NSString *realName;

/// 是否三方登录
@property (nonatomic,assign) BOOL isOtherLogin;

/// otherLoginResult登录请求参数
@property (nonatomic,strong) NSDictionary *otherLoginResult;

+ (User *)shareUser;

- (void)clearData;

//删除用户数据
- (void)deleteUesr;

//  当变更数据后，保存到文件
- (void)saveUser;

// 从文件中读取 这个方法是app刚进来的时候去调用
+ (instancetype)userFromFile;

//  记录用户登录
+ (void)saveLogin;

//  记录用户退出
+ (void)saveExit;

+ (BOOL)isLogin;
@end
