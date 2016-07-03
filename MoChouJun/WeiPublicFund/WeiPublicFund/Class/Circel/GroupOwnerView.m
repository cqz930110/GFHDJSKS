//
//  GroupOwnerView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "GroupOwnerView.h"
#import "NetWorkingUtil.h"
#import "PSBuddy.h"
@interface GroupOwnerView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation GroupOwnerView
- (void)awakeFromNib
{
    _headImageView.layer.cornerRadius = _headImageView.width * 0.5;
    _headImageView.layer.masksToBounds = YES;
}
- (void)setBuddy:(PSBuddy *)buddy
{
    _buddy = buddy;
    [NetWorkingUtil setImage:_headImageView url:_buddy.avatar defaultIconName:@"home_默认"];
    _nameLabel.text = _buddy.reviewName;
}

- (IBAction)clicke:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(gotoGroupOwnerDetail:)])
    {
        [self.delegate gotoGroupOwnerDetail:_buddy];
    }
}
@end
