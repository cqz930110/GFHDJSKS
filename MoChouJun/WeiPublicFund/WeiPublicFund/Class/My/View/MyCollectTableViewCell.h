//
//  MyCollectTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *myCollectIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *myCollectTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *myCollectContentLab;
@property (weak, nonatomic) IBOutlet UILabel *myCollectStateLab;
@property (weak, nonatomic) IBOutlet UILabel *myCollectMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *myCollectSupportLab;
@property (weak, nonatomic) IBOutlet UIButton *myCollectCancelBtn;

@property (nonatomic,copy)NSDictionary *myCollectDic;

@end
