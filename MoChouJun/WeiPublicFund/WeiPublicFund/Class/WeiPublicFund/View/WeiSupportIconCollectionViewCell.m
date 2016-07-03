//
//  WeiSupportIconCollectionViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "WeiSupportIconCollectionViewCell.h"

@implementation WeiSupportIconCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _supportImageView.layer.cornerRadius = 15.0f;
    _supportImageView.layer.masksToBounds = YES;
}

@end
