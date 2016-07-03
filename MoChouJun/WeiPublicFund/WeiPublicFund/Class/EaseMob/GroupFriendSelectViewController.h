//
//  GroupFriendSelectViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/16.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupFriendSelectViewController : BaseViewController
@property (copy, nonatomic) NSString *groupId;

@property (copy) void (^didSelectRowAtIndexPathCompletion)(id object);
@end
