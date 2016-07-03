//
//  User.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/27.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "User.h"
#import <YYModel.h>
@implementation User
static User *instance = nil;
//MJCodingImplementation

+ (User *)shareUser
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[super allocWithZone:NULL] init];
        });
    }
    return instance;
}

#pragma mark - YYModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"name",@"userName",@"nikeName",@"password",@"Id",@"avatar"];
//}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareUser];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

- (void)saveUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefaults setObject:data forKey:@"user"];
    [userDefaults synchronize];
}

- (void)clearData
{
    self.Id = [NSNumber numberWithInt:0];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
    [self saveUser];
}

- (void)deleteUesr
{
    self.mobile = @"";
    self.nickName = @"";
    self.password = @"";
    self.Id = [NSNumber numberWithInt:0];
    self.isOtherLogin = NO;
    self.otherLoginResult = nil;
    self.realName = @"";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user"];
    [userDefaults synchronize];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
}

+ (instancetype)userFromFile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"user"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)saveLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:KHaveLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveExit
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KHaveLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)isLogin
{
    User *user = [User shareUser];
    if (user == nil || [user.Id intValue] == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }

}
@end
