//
//  MyStartGoReturnTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartGoReturnTableViewCell.h"

@implementation MyStartGoReturnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyStartGoReturnDic:(NSDictionary *)myStartGoReturnDic
{
    _myStartGoReturnDic = myStartGoReturnDic;
    
    NSString *userName = IsStrEmpty([_myStartGoReturnDic objectForKey:@"NickName"])?[_myStartGoReturnDic objectForKey:@"UserName"]:[_myStartGoReturnDic objectForKey:@"NickName"];
    _myStartNickNameLab.text = [NSString stringWithFormat:@"昵称：%@",userName];
    _myStartDateLab.text = [_myStartGoReturnDic objectForKey:@"CreateDate"];
    _myStartReciveLab.text = [NSString stringWithFormat:@"收件人：%@",[_myStartGoReturnDic objectForKey:@"RecvName"]];
    _myStartNumberLab.text = [NSString stringWithFormat:@"数量：%@件",[_myStartGoReturnDic objectForKey:@"Count"]];
    _myStartPhoneLab.text = [NSString stringWithFormat:@"电话：%@",[_myStartGoReturnDic objectForKey:@"Mobile"]];
    _myStartAddressLab.text = [NSString stringWithFormat:@"收件地址：%@",[_myStartGoReturnDic objectForKey:@"AddressInfo"]];
    
    if ([[_myStartGoReturnDic objectForKey:@"StautsId"] integerValue] == 0) {
        _myStartTypeStateLab.text = [_myStartGoReturnDic objectForKey:@"ShowStatus"];
        _myStartGoReturnBtn.hidden = NO;
        _myStartTypeStateLab.hidden = NO;
        _myStartTypeStateLabel.hidden = YES;
        _myStartExpressLab.hidden = YES;
    }else{
        _myStartTypeStateLabel.hidden = NO;
        _myStartExpressLab.hidden = NO;
        _myStartTypeStateLabel.text = [NSString stringWithFormat:@"%@",[_myStartGoReturnDic objectForKey:@"ShowStatus"]];
        _myStartExpressLab.text = [NSString stringWithFormat:@"%@ %@",[_myStartGoReturnDic objectForKey:@"ExpressName"],[_myStartGoReturnDic objectForKey:@"ExpressNo"]];
        _myStartTypeStateLab.hidden = YES;
        _myStartGoReturnBtn.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
