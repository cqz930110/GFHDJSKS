//
//  MyStartNoReturnTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartNoReturnTableViewCell.h"

@implementation MyStartNoReturnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyStartNoReturnDic:(NSDictionary *)myStartNoReturnDic
{
    _myStartNoReturnDic = myStartNoReturnDic;
    
    _myStartNoReturnTotalLab.text = [NSString stringWithFormat:@"获得%@次的支持，共计%@元",[_myStartNoReturnDic objectForKey:@"SupportCount"],[_myStartNoReturnDic objectForKey:@"RaisedAmount"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
