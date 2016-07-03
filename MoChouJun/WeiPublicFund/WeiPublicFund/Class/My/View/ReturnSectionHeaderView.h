//
//  ReturnSectionHeaderView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/31.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectReturn;
@class ReturnSectionHeaderView;
@protocol ReturnSectionHeaderViewDelegate <NSObject>
- (void)headerViewOpenStateChanged:(ReturnSectionHeaderView *)headerView;
@end

@interface ReturnSectionHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) ProjectReturn *projectReturn;
@property (weak, nonatomic) id<ReturnSectionHeaderViewDelegate> delegate;
@end
