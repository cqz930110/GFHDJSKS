//
//  TongXunLuCommonTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/13.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "TongXunLuCommonTableViewCell.h"

@implementation TongXunLuCommonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _numberLab.layer.cornerRadius = 9.0f;
    _numberLab.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
