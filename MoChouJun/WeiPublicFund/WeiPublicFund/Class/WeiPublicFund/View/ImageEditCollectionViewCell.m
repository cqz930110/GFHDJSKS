//
//  ImageEditCollectionViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ImageEditCollectionViewCell.h"

@implementation ImageEditCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)longPressDeleteAction:(UILongPressGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteUploadImageSssetCertificationCell:)]) {
        [self.delegate deleteUploadImageSssetCertificationCell:self];
    }
}

@end
