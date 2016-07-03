//
//  ProjectReturnHeaderView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportReturnMamager;
@class ProjectReturnHeaderView;


@protocol ProjectReturnHeaderViewDelegate <NSObject>
- (void)projectReturnCellOpenStateChanged:(ProjectReturnHeaderView *)headerView;
@end
@interface ProjectReturnHeaderView : UIView
@property (weak, nonatomic) SupportReturnMamager *supportReturnManager;
@property (weak, nonatomic) id<ProjectReturnHeaderViewDelegate> delegate;
@end
