//
//  RecommendHomeTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/3.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Project;
@class PageTableController;

@interface RecommendHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *supportPeopleLab;
@property (weak, nonatomic) IBOutlet UILabel *supleDayLab;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;

@property (nonatomic,weak)PageTableController *delegate;

@property (nonatomic,copy)Project *project;
@end
