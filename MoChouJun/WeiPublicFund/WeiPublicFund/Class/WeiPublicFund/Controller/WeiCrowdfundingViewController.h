//
//  WeiCrowdfundingViewController.h
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "BaseViewController.h"

@class ProjectTableViewCell;
@interface WeiCrowdfundingViewController : BaseViewController

//   ProjectTableViewCell delegate
- (void)projectTableViewCell:(ProjectTableViewCell *)cell supportProject:(id)project;

@end
