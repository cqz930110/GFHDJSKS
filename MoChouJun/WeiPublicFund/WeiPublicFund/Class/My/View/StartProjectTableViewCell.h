//
//  StartProjectTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyStartReturnObj;
@interface StartProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startProjectTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *startProjectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *startProjectStateLab;
@property (weak, nonatomic) IBOutlet UILabel *startProjectAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *startProjectMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *skipProjectDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *startProjectContentLab;
@property (weak, nonatomic) IBOutlet UIButton *revokeBtn;
@property (weak, nonatomic) IBOutlet UIButton *editProjectBtn;
@property (weak, nonatomic) IBOutlet UIButton *projectDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *myStartReturnBtn;

@property (nonatomic,copy)MyStartReturnObj *myStartReturnObj;

@end
