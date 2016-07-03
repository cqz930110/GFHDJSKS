//
//  NoExpressTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "NoExpressTableViewCell.h"
#import "ExpressObj.h"

@implementation NoExpressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setExpress:(ExpressObj *)express
{
    _express = express;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@.00",_express.supportAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _noExpressMoneyLab.attributedText = atriText;
    
    _noExpressContentLab.text = _express.Description;
    
    _noExpressDataLab.text = [NSString stringWithFormat:@"数量：%d件 %@",_express.count,_express.createDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
