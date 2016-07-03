//
//  BaseDataEditViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseDataEditViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *baseDataEditTextField;

@property (nonatomic,copy)NSString *baseDataStr;
@property (nonatomic,copy)NSString *titleStr;
@end
