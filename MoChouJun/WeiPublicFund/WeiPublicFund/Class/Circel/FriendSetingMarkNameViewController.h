//
//  FriendSetingMarkNameViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/21.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class FriendSetingMarkNameViewController;

@protocol FriendSetingMarkNameViewControllerDelegate <NSObject>

- (void)showMarkName:(NSString *)name;

@end

@interface FriendSetingMarkNameViewController : BaseViewController

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *notes;

@property (nonatomic,weak)id<FriendSetingMarkNameViewControllerDelegate>delegate;
@end
