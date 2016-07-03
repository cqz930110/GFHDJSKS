//
//  ProjectTableViewCell.h
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;
@class WeiCrowdfundingViewController;
@class Project;
@class CrowdFundingObj;
@class PageTableController;
@interface ProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *realNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *projectTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *projectContentLab;
@property (weak, nonatomic) IBOutlet UICollectionView *projectCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *surplusLab;
@property (weak, nonatomic) IBOutlet UIButton *chatGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatFrientBtn;
@property (weak, nonatomic) IBOutlet UILabel *targetRaiseLab;
@property (weak, nonatomic) IBOutlet UILabel *supportNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *profileContentLab;

@property (nonatomic,weak)PageTableController *delegate;

@property (strong, nonatomic) Project *project;
@property (nonatomic,strong)CrowdFundingObj *crowdFundingObj;
@end
