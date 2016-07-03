//
//  RaiseFundsTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/6.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaiseFundsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *raiseFundUserIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameAddstateLab;
@property (weak, nonatomic) IBOutlet UILabel *raiseStateTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *raiseReturnLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic,copy)NSDictionary *raiseFundDic;
@end
