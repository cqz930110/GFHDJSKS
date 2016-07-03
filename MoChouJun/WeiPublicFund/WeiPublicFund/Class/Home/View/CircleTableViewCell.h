//
//  CircleTableViewCell.h
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;
@interface CircleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageNewLab;
@property (weak, nonatomic) IBOutlet UIButton *messageIconBtn;

@property (nonatomic,weak)HomeViewController *delegate;
@end
