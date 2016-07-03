//
//  ProjectReturn.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/31.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectReturn.h"
#import "ReflectUtil.h"

@implementation ProjectReturn
- (void)setSupportPeoples:(NSArray *)supportPeoples
{
    
    _supportPeoples = [ReflectUtil reflectDataWithClassName:@"SupportedProject" otherObject:supportPeoples isList:YES];
}
@end

