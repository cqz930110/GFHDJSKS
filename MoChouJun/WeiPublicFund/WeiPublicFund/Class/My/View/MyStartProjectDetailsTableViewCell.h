//
//  MyStartProjectDetailsTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStartProjectDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myStartMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartContentLab;
@property (weak, nonatomic) IBOutlet UILabel *myStartReturnTotalLab;
@property (weak, nonatomic) IBOutlet UIButton *myStartBtn;

@property (nonatomic,copy)NSDictionary *myStartDic;
@end
