//
//  GroupNoticeViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@protocol GroupNoticeViewControllerDelegate<NSObject>
- (void)changeGroupNotice:(NSString *)groupNotice;
@end

@interface GroupNoticeViewController : BaseViewController
@property (assign, nonatomic) BOOL canEdit;
@property (copy, nonatomic) NSString *groupId;
@property (weak, nonatomic) id<GroupNoticeViewControllerDelegate> delegate;
@end
