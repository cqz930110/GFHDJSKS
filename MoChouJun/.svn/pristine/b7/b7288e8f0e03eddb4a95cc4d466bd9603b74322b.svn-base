//
//  GoSupportViewCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "GoSupportViewCell.h"
@interface GoSupportViewCell ()



@end

@implementation GoSupportViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected)
    {
        _optionedImageView.hidden = NO;
    }
    else
    {
        _optionedImageView.hidden = YES;
    }
}


- (void)iconImageName:(NSString *)iconImageName title:(NSString *)title
{
    _titleLabel.text = title;
    _iconImageView.image = [UIImage imageNamed:iconImageName];
}

@end
