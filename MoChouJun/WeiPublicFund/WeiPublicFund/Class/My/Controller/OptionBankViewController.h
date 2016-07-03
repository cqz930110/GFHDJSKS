//
//  OptionBankViewController.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/14.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
@protocol OptionBankViewControllerDelegate<NSObject>
- (void)optionBankTypeUserInfo:(NSDictionary *)bankDic;
@end
@interface OptionBankViewController : BaseViewController
@property (nonatomic , weak) id<OptionBankViewControllerDelegate> delegate;
@end
