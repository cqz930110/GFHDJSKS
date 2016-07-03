//
//  MyStartReturnListTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartReturnListTableViewCell.h"

@implementation MyStartReturnListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyStartReturnListDic:(NSDictionary *)myStartReturnListDic
{
    _myStartReturnListDic = myStartReturnListDic;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",[[_myStartReturnListDic objectForKey:@"SupportAmount"] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _myStartMoneyLab.attributedText = atriText;
    _myStartContentLab.text = [NSString stringWithFormat:@"回报介绍：%@",[_myStartReturnListDic objectForKey:@"Description"]];
    _myStartCountLab.text = [NSString stringWithFormat:@"%@次支持",[_myStartReturnListDic objectForKey:@"SupportCount"]];
    _myStartStateLab.text = [_myStartReturnListDic objectForKey:@"ShowStatus"];
    if([[_myStartReturnListDic objectForKey:@"RepayDays"] integerValue] != 0)
    {
        NSString *commintText = @"众筹承诺：众筹成功内发货";
        NSMutableAttributedString *commintTotalText = [[NSMutableAttributedString alloc] initWithString:commintText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#7F7F7F"]}];
        NSAttributedString *repayDaysText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",[_myStartReturnListDic objectForKey:@"RepayDays"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]}];
        [commintTotalText insertAttributedString:repayDaysText atIndex:commintText.length - 3];
        _myStartPromiseLab.attributedText = commintTotalText;
        
    }
    else
    {
        _myStartPromiseLab.text = @"众筹承诺：众筹成功立即发货";
    }

    _myStartDateLab.text = [NSString stringWithFormat:@"%@",[_myStartReturnListDic objectForKey:@"ShowRemainDay"]];
    NSLog(@"------%d",[[_myStartReturnListDic objectForKey:@"StatusId"] intValue]);
    if ([[_myStartReturnListDic objectForKey:@"StatusId"] intValue] == 1) {
        [_goReturnBtn setImage:[UIImage imageNamed:@"myStartGoRerurn"] forState:UIControlStateNormal];
    }else{
        [_goReturnBtn setImage:[UIImage imageNamed:@"myStartSeeReturn"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
