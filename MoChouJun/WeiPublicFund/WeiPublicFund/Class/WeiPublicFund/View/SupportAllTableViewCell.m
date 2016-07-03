//
//  SupportAllTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SupportAllTableViewCell.h"
#import "SupportReturn.h"
@implementation SupportAllTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSupport:(SupportReturn *)support
{
    _support = support;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_support.supportAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _returnAmountLab.attributedText = atriText;
    
    _returnContentLab.text = _support.Description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
