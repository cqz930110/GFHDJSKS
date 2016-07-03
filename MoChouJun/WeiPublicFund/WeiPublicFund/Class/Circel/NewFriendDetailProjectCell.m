//
//  FriendDetailProjectCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "NewFriendDetailProjectCell.h"
#import "NetWorkingUtil.h"
@interface NewFriendDetailProjectCell()

@end
@implementation NewFriendDetailProjectCell

- (void)awakeFromNib
{
    _imageView.layer.cornerRadius = _imageView.width * 0.5;
    _imageView.layer.masksToBounds = YES;
}

- (void)setimageUrl:(NSString *)imageUrl
{
    if (IsStrEmpty(imageUrl))
    {
        _imageView.image = [UIImage imageNamed:@"home_默认"];
    }
    else
    {
        [NetWorkingUtil  setImage:_imageView url:imageUrl defaultIconName:nil];
    }
}

- (void)setUserName:(NSString *)userNameStr
{
    if (IsStrEmpty(userNameStr)) {
        _userNameLab.text = @"";
    }else{
        _userNameLab.text = userNameStr;
    }
}
@end
