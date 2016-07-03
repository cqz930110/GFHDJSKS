//
//  IconImageCollectionViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "IconImageCollectionViewCell.h"

@implementation IconImageCollectionViewCell

- (void)awakeFromNib {
    _iconImageView.layer.cornerRadius = 22.0f;
    _iconImageView.layer.masksToBounds = YES;
}

@end
