//
//  MyCollectTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyCollectTableViewCell.h"
#import "UIButton+EMWebCache.h"

@implementation MyCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _myCollectIconBtn.layer.cornerRadius = 17.5f;
    _myCollectIconBtn.layer.masksToBounds = YES;
}

- (void)setMyCollectDic:(NSDictionary *)myCollectDic
{
    _myCollectDic = myCollectDic;
    
    [_myCollectIconBtn sd_setImageWithURL:[NSURL URLWithString:[_myCollectDic objectForKey:@"Avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    _myCollectTitleLab.text = [_myCollectDic objectForKey:@"Name"];
    _myCollectContentLab.text = [_myCollectDic objectForKey:@"Content"];
    _myCollectMoneyLab.text = [NSString stringWithFormat:@"已筹¥%@  目标¥%@",[_myCollectDic objectForKey:@"RaisedAmount"],[_myCollectDic objectForKey:@"TargetAmount"]];
    _myCollectSupportLab.text = [NSString stringWithFormat:@"%@人支持 %@",[_myCollectDic objectForKey:@"SupportCount"],[_myCollectDic objectForKey:@"ShowStatus"]];
    if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 0) {
        _myCollectStateLab.text = @"进行中";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 1){
        _myCollectStateLab.text = @"集资完成";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 2){
        _myCollectStateLab.text = @"回报中";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 3){
        _myCollectStateLab.text = @"成功";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 4){
        _myCollectStateLab.text = @"已撤销";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 5){
        _myCollectStateLab.text = @"失败";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 6){
        _myCollectStateLab.text = @"禁用";
    }else if ([[_myCollectDic objectForKey:@"ShowStatus"] integerValue] == 7){
        _myCollectStateLab.text = @"删除";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
