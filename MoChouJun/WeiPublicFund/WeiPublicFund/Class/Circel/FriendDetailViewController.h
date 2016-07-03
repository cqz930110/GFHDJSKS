//
//  FriendDetailViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
typedef  NS_ENUM(NSInteger,FriendDetailType)
{
    FriendDetailTypeUnBuddy,
    FriendDetailTypeBuddy
};
@class PSBuddy;
@interface FriendDetailViewController : BaseViewController
@property (assign, nonatomic) FriendDetailType friendDetailType;
@property (copy, nonatomic) NSString *searchMobile;// 通讯录电话  一种跳转方式
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) PSBuddy *buddy;

@end