//
//  AddGroupNoticeViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class GroupNotice;
@protocol AddGroupNoticeViewControllerDelegate<NSObject>
- (void)changeGroupNotice:(NSString *)groupNotice;
@end
@interface AddGroupNoticeViewController : BaseViewController
@property (copy, nonatomic) NSString *groupId;
@property (strong, nonatomic) GroupNotice *notice; //   原来的
@property (nonatomic,copy) NSString *noticeStr;

@property (nonatomic,copy)NSString *type;

@property (weak, nonatomic) id<AddGroupNoticeViewControllerDelegate> delegate;
@end
