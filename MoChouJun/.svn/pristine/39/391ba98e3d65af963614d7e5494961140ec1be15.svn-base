//
//  ReturnSectionHeaderView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/31.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ReturnSectionHeaderView.h"
#import "ProjectReturn.h"
@interface ReturnSectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *returnNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
@implementation ReturnSectionHeaderView

- (IBAction)openStateAction:(id)sender
{
    _projectReturn.openState = !_projectReturn.openState;
    if ([self.delegate respondsToSelector:@selector(headerViewOpenStateChanged:)])
    {
        [self.delegate headerViewOpenStateChanged:self];
    }
}

- (void)setProjectReturn:(ProjectReturn *)projectReturn
{
    _projectReturn = projectReturn;
    _returnNameLabel.text = _projectReturn.returnName;
    
    if (_projectReturn.openState)
    {
        _arrowImageView.image = [UIImage imageNamed:@"收起"];
    }
    else
    {
        _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
}

@end
