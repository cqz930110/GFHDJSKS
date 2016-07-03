//
//  ChangeGroupNameViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@protocol ChangeGroupNameViewControllerDelegate
- (void)changeGroupName:(NSString *)groupName;
@end
@interface ChangeGroupNameViewController : BaseViewController

@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *groupName;
@property (weak, nonatomic) id<ChangeGroupNameViewControllerDelegate> delegate;
@end
