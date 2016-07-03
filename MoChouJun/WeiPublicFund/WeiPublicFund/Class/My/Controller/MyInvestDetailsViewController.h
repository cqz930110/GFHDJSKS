//
//  MyInvestDetailsViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class SupportedProject;
@protocol MyInvestDetailsViewControllerDelegate <NSObject>
- (void)myInvestDetailsViewControllerDelegate:(SupportedProject *)supportProject;
@end

@interface MyInvestDetailsViewController : BaseViewController
@property (nonatomic,strong)NSString *fromStartProject;
@property (nonatomic,strong)NSString *upStateProject;
@property (strong, nonatomic) SupportedProject *supportProject;
@property (weak, nonatomic) id<MyInvestDetailsViewControllerDelegate> delegate;
@end
