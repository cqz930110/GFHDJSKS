//
//  MyInvestDetailTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MyInvestDetailTableViewCell.h"
#import "NSString+Adding.h"
@implementation MyInvestDetailTableViewCell
- (void)setContent:(NSString *)content
{
    _content = content;
    CGFloat height = [_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 105, 999)].height;
    if (height<44)
    {
        return;
    }
    CGRect rect = _myInvestDetailLab.frame;
    rect.size.height =  height;
    _myInvestDetailLab.frame = rect;
}
@end
