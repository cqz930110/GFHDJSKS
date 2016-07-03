//
//  RecommendHomeTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/3.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "RecommendHomeTableViewCell.h"
#import "Project.h"
#import "NetWorkingUtil.h"
#import "UIButton+WebCache.h"
#import "PageTableController.h"

@implementation RecommendHomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _userIconBtn.layer.cornerRadius = 16.5f;
    _userIconBtn.layer.masksToBounds = YES;
}
- (IBAction)userIconClickEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recommendHomeTableViewCell:supportProject:)]) {
        [self.delegate recommendHomeTableViewCell:self supportProject:nil];
    }
}

- (void)setProject:(Project *)project
{
    _project = project;
    _projectNameLab.text = project.name;
    _supportPeopleLab.text = [NSString stringWithFormat:@"%d次支持",project.supportCount];
    _supleDayLab.text = project.showStatus;
    [_userIconBtn sd_setImageWithURL:[NSURL URLWithString:project.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    [_projectImageView sd_setImageWithURL:[NSURL URLWithString:project.images[0]] placeholderImage:nil];
    _amountLab.text = [NSString stringWithFormat:@"¥%@／%@",project.raisedAmount,project.targetAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
