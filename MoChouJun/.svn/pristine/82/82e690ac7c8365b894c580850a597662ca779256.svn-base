//
//  GroupFriendSelectTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/16.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "GroupFriendSelectTableViewCell.h"
#import "NetWorkingUtil.h"
#import "PSBuddy.h"
#import "UIImageView+HeadImage.h"

@implementation GroupFriendSelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBuddy:(PSBuddy *)buddy
{
    _buddy = buddy;
    [_peopleNameLab setTextWithUsername:_buddy.reviewName];
    [NetWorkingUtil setImage:_peopleImageView url:_buddy.avatar defaultIconName:@"home_默认"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
