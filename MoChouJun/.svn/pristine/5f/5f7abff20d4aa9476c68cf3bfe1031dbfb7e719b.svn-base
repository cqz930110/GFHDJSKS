//
//  NewAddFriendCollectionViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/30.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "NewAddFriendCollectionViewCell.h"

@implementation NewAddFriendCollectionViewCell

- (void)awakeFromNib {
    _addImageView.layer.cornerRadius = _addImageView.width * 0.5;
    _addImageView.layer.masksToBounds = YES;
}

- (void)setimageUrl:(NSString *)imageUrl
{
    if (IsStrEmpty(imageUrl))
    {
        _addImageView.image = [UIImage imageNamed:@"home_默认"];
    }
    else
    {
        [NetWorkingUtil  setImage:_addImageView url:imageUrl defaultIconName:nil];
    }
}

@end
