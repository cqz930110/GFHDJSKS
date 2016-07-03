//
//  JDpayViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@protocol JDpayViewControllerDelegate<NSObject>
- (void)jdPayFinishedSupportId:(NSString *)supportId;
@end

@interface JDpayViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *parmas;
@property (weak, nonatomic) id<JDpayViewControllerDelegate> delegate;
@end
