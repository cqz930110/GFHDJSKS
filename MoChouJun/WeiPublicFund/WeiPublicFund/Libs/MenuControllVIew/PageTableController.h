//
//  PageTableController.h
//  ScrollViewAndTableView
//
//  Created by fantasy on 16/5/14.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectTableViewCell;
@class RecommendHomeTableViewCell;
typedef void(^TableViewDidScrollBlock)(CGFloat tableViewOffsetY);

@interface PageTableController : UITableViewController

@property (assign, nonatomic) int numOfController;

@property (copy, nonatomic) TableViewDidScrollBlock tableViewDidScroll;

@property (copy, nonatomic) TableViewDidScrollBlock tableViewDidEndDecelerating;
@property (copy, nonatomic) TableViewDidScrollBlock tableViewDidEndDragging;
@property (copy, nonatomic) TableViewDidScrollBlock tableViewWillBeginDragging;
@property (copy, nonatomic) TableViewDidScrollBlock tableViewWillBeginDecelerating;

- (void)updateTableViewIndex:(int)index;

- (void)projectTableViewCell:(ProjectTableViewCell *)cell supportProject:(id)project;
- (void)recommendHomeTableViewCell:(RecommendHomeTableViewCell *)cell supportProject:(id)project;
@end
