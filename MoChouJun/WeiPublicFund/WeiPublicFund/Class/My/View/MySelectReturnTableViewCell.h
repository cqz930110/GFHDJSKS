//
//  MySelectReturnTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySelectReturnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myInvestMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *myInvestContentLab;
@property (weak, nonatomic) IBOutlet UILabel *myInvestNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *myInvestDataLab;
@property (weak, nonatomic) IBOutlet UIImageView *myInvestStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (nonatomic,copy)NSDictionary *myInvestDic;
@end
