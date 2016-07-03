//
//  PSChat.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "PSChat.h"
@implementation PSChat

- (NSString *)showName
{
    if (!IsStrEmpty(_showName))
    {
        return _showName;
    }
    
    if (_notes.length > 0)
    {
        _showName = _notes;
    }
    else if (_name.length > 0)
    {
        _showName = _name;
    }
    else
    {
        _showName = _value;
    }
    return _showName;
}

- (NSString *)userName
{
    return _value;
}

- (void)setUserName:(NSString *)userName
{
    _value = userName;
}

- (NSString *)nikeName
{
    return _name;
}

- (void)setNikeName:(NSString *)nikeName
{
    _name = nikeName;
}
@end
