//
//  PSBuddy.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/16.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "PSBuddy.h"

@implementation PSBuddy

static PSBuddy *instance = nil;
//MJCodingImplementation

+ (PSBuddy *)sharePSBuddy
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
- (NSString *)reviewName
{
    if (_notes.length > 0)
    {
        return _notes;
    }
    else if (_nickName.length > 0)
    {
        return _nickName;
    }
    else
    {
        return _userName;
    }
}

- (NSString *)nickName
{
    if (_nickName.length > 0)
    {
        return _nickName;
    }
    else
    {
        return _userName;
    }
}
@end
