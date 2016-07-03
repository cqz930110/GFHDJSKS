//
//  NewFriendDeatailViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
typedef  NS_ENUM(NSInteger,ChatFriendDetailType)
{
    ChatFriendDetailTypeBuddy,
    ChatFriendDetailTypeUnBuddy
};

@class ApplyEntity;
@interface ChatFriendDeatailViewController : BaseViewController
/**
 *  这个参数是在好友申请界面
 */
@property (strong, nonatomic) ApplyEntity *entity;
/**
 *  这个参数在外面制定，界面不同
 */
@property (assign, nonatomic) ChatFriendDetailType chatFriendDetailType;
/**
 *  这个参数一定要给,用于请求接口
 */
@property (copy, nonatomic) NSString *username;
@end
