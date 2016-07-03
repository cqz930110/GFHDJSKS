//
//  ProjectContentCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/30.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectDetailsObj;
@class ProjectContentCell;
@protocol ProjectContentCellDelegate <NSObject>
- (void)projectContentCellOpenStateChanged:(ProjectContentCell *)cell;
@end

@interface ProjectContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addProjectDetailsBtn;
@property (nonatomic, weak) id<ProjectContentCellDelegate> delegate;
@property (nonatomic, strong) ProjectDetailsObj *projectDetail;
@end
