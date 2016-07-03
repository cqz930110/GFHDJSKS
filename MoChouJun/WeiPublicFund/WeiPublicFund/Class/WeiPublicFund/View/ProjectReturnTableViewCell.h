//
//  ProjectReturnTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectReturnViewController;
@interface ProjectReturnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *returnAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *returnPeopleLab;
@property (weak, nonatomic) IBOutlet UILabel *returnContentLab;
@property (weak, nonatomic) IBOutlet UILabel *returnPeriodLab;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *returnLab1;
@property (weak, nonatomic) IBOutlet UILabel *returnLab2;

@property (nonatomic,strong)NSDictionary *projectReturnDic;

@property (nonatomic,weak)ProjectReturnViewController *delegates;
@property (weak, nonatomic) IBOutlet UIImageView *returnImageView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,copy)NSDictionary *allReturnDic;
@end
