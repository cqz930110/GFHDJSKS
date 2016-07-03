//
//  BankBankchViewController.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/2/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class BankBankch;
@protocol BankBankchViewControllerDelegate <NSObject>
- (void)optionBankBranck:(BankBankch *)bankBankch;
@end

@interface BankBankchViewController : BaseViewController
/// 银行类型ID
@property (assign, nonatomic) int bankTypeId;
/// 区域ID
@property (assign, nonatomic) NSInteger districtId;

@property (weak, nonatomic) id<BankBankchViewControllerDelegate> delegate;
@end


