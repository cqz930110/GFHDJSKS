//
//  ContactListViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "GroupListsViewController.h"

@interface ContactListViewController : EaseUsersListViewController

@property (strong, nonatomic) GroupListsViewController *groupController;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//添加好友的操作被触发
- (void)addFriendAction;

@end
