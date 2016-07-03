//
//  MyStartReturnListTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStartReturnListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myStartMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartContentLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartCountLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartStateLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartPromiseLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartDateLab;
@property (weak, nonatomic) IBOutlet UIButton *goReturnBtn;

@property (nonatomic,copy)NSDictionary *myStartReturnListDic;
@end
