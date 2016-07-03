//
//  ProjectHtmlContentCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/5/11.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectHtmlContentCell.h"
#import "ProjectDetailsObj.h"

@interface ProjectHtmlContentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation ProjectHtmlContentCell
static const CGFloat projectContentMargin = 10.0;
- (void)setProjectDetail:(ProjectDetailsObj *)projectDetail
{
    //========name=========
    _projectDetail = projectDetail;
    
    CGFloat height = projectContentMargin;
    _nameLabel.text = _projectDetail.name;
    _nameLabel.height = [_projectDetail nameTextHeight];
    height +=  _nameLabel.height; //name 高度
    //=========profile=========
    height += projectContentMargin;
    _detailLabel.text = _projectDetail.profile;
    _detailLabel.top = height;
    _detailLabel.height = [_projectDetail profileTextHeight];
}

+ (CGFloat)basicHeightWithProjectDetail:(ProjectDetailsObj *)project
{
    CGFloat height = projectContentMargin;
    height +=  [project nameTextHeight]; //name 高度
    //=========profile=========
    height += projectContentMargin;
    height += [project profileTextHeight];
    height += projectContentMargin;
    return height;
}
@end
