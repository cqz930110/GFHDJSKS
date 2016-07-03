//
//  MyInvestProjectTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MyInvestProjectTableViewCell.h"
#import "NetWorkingUtil.h"
#import "SupportedProject.h"
@implementation MyInvestProjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _myIconBtn.layer.cornerRadius = 15.0f;
    _myIconBtn.layer.masksToBounds = YES;
}

- (void)setSupporyedProject:(SupportedProject *)supporyedProject
{
    _supporyedProject = supporyedProject;
    UIImageView *imageView = [[UIImageView alloc]init];
    [NetWorkingUtil setImage:imageView url:_supporyedProject.avatar defaultIconName:@"home_默认"];
    [_myIconBtn setImage:imageView.image forState:UIControlStateNormal];
    _myNameLab.text = _supporyedProject.name;
    _myProjectStateLab.text = _supporyedProject.showStatus;
    _myProjectNameLab.text = _supporyedProject.content;
    _myProjectAmountLab.text = [NSString stringWithFormat:@"已筹¥%@ 目标¥%@",_supporyedProject.raisedAmount,_supporyedProject.targetAmount];
    _supportNumberLab.text = [NSString stringWithFormat:@"%ld次支持 %@",(long)_supporyedProject.supportCount,_supporyedProject.remainTime];

    if (_supporyedProject.statusId == 2 || _supporyedProject.statusId == 3) {
        _expressBtn.hidden = NO;
    }else{
        _expressBtn.hidden = YES;
    }
    //
    if (_supporyedProject.statusId == 2 || _supporyedProject.statusId == 3) {
        _commitReturnBtn.hidden = NO;
        [_commitReturnBtn setImage:[UIImage imageNamed:@"commitReturn"] forState:UIControlStateNormal];
    }else if (_supporyedProject.statusId == 4 || _supporyedProject.statusId == 5 || _supporyedProject.statusId == 6){
        _commitReturnBtn.hidden = NO;
        [_commitReturnBtn setImage:[UIImage imageNamed:@"mySupportDelete"] forState:UIControlStateNormal];
    }else{
        _commitReturnBtn.hidden = YES;
    }
    
    if (_supporyedProject.repayCount == 0) {
        _commitReturnBtn.hidden = YES;
        _expressBtn.hidden = YES;
    }else{
        _commitReturnBtn.hidden = NO;
        _expressBtn.hidden = NO;
    }
}

@end
