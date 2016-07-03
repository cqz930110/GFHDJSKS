//
//  MyStartNoReturnExpressTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/23.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartNoReturnExpressTableViewCell.h"

@implementation MyStartNoReturnExpressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyStartGoReturnDic:(NSDictionary *)myStartGoReturnDic
{
    _myStartGoReturnDic = myStartGoReturnDic;
    
    NSString *userName = IsStrEmpty([_myStartGoReturnDic objectForKey:@"NickName"])?[_myStartGoReturnDic objectForKey:@"UserName"]:[_myStartGoReturnDic objectForKey:@"NickName"];
    _myStartNickNameLab.text = [NSString stringWithFormat:@"昵称:%@",userName];
    _myStartDateLab.text = [_myStartGoReturnDic objectForKey:@"CreateDate"];
    _myStartNumberLab.text = [NSString stringWithFormat:@"数量:%@件",[_myStartGoReturnDic objectForKey:@"Count"]];
    _myStartStateLab.text = [_myStartGoReturnDic objectForKey:@"ShowStatus"];
    
    if ([[_myStartGoReturnDic objectForKey:@"StatusId"] integerValue] == 0) {
        _myStartGoReturnBtn.hidden = NO;
    }else{
        _myStartGoReturnBtn.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
