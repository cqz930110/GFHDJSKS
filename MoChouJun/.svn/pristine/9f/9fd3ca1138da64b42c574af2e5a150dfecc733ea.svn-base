//
//  MyStartProjectDetailsTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartProjectDetailsTableViewCell.h"

@implementation MyStartProjectDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyStartDic:(NSDictionary *)myStartDic
{
    _myStartDic = myStartDic;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",[[_myStartDic objectForKey:@"SupportAmount"] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _myStartMoneyLab.attributedText = atriText;
    
    _myStartContentLab.text = [_myStartDic objectForKey:@"Description"];
    _myStartReturnTotalLab.text = [NSString stringWithFormat:@"获得%@次的支持，共计%@元",[_myStartDic objectForKey:@"SupportCount"],[_myStartDic objectForKey:@"RaisedAmount"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
