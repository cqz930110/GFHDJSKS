//
//  SupportMethodViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/17.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class SupportReturn;
@interface SupportMethodViewController : BaseViewController

@property (strong, nonatomic) SupportReturn *support;
@property (nonatomic,strong)NSDictionary *addressDic;
@end
