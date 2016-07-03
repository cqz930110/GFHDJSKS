//
//  MySupportPeopleViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class MyStartReturnObj;
@protocol SupportReturnViewControllerDelegate<NSObject>
- (void)supportReturnStateDidChangeReturn:(MyStartReturnObj *)startReturn;
@end

@interface SupportReturnViewController : BaseViewController
@property (strong, nonatomic) MyStartReturnObj *myStartReturn;
@property (weak, nonatomic) id<SupportReturnViewControllerDelegate> delegate;
@end
