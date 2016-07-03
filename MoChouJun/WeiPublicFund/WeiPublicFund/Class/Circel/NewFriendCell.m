//
//  NewFriendCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/15.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "NewFriendCell.h"

@implementation NewFriendCell

- (void)awakeFromNib
{
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = 35 * 0.5;
}
@end
