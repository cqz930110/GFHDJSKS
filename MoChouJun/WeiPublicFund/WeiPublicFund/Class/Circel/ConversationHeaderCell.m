
//
//  ConversationHeaderCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ConversationHeaderCell.h"

@implementation ConversationHeaderCell
-(void)awakeFromNib
{
    _contactUnReadLabel.layer.cornerRadius = _contactUnReadLabel.width * 0.5;
    _systemMessageUnreadLabel.layer.cornerRadius = _systemMessageUnreadLabel.width * 0.5;
    _systemMessageUnreadLabel.layer.masksToBounds = YES;
    _contactUnReadLabel.layer.masksToBounds = YES;
}

- (IBAction)clickHeader:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(optionHeaderCell:optionType:)])
    {
        [self.delegate optionHeaderCell:self optionType:sender.tag];
    }
}

@end
