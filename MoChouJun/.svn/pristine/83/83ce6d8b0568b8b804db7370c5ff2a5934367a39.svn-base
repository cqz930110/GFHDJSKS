//
//  AddPopoverView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/14.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AddPopoverView.h"
@interface AddPopoverView()

@end

@implementation AddPopoverView

- (IBAction)addAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addPopoverView:addActionType:)])
    {
        [self.delegate addPopoverView:self addActionType:sender.tag];
    }
}

- (void)showAnimation
{
    if (self.height > 0)
    {
        [UIView animateWithDuration:.25 animations:^{
            self.height = 0.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:.25 animations:^{
            self.height = 85.0;
        }];

    }
    [self setNeedsLayout];
}

@end
