//
//  MyStartGoReturnTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStartGoReturnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myStartNickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartDateLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartReciveLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartAddressLab;
@property (weak, nonatomic) IBOutlet UIButton *myStartSendMsgBtn;
@property (weak, nonatomic) IBOutlet UILabel *myStartTypeStateLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartTypeStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *myStartExpressLab;
@property (weak, nonatomic) IBOutlet UIButton *myStartGoReturnBtn;

@property (nonatomic,copy)NSDictionary *myStartGoReturnDic;
@end
