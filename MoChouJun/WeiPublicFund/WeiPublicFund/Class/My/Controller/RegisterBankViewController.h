//
//  RegisterBankViewController.h
//  PublicFundraising
//
//  Created by liuyong on 15/11/6.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
@protocol RegisterBankViewControllerDelegate<NSObject>
- (void)registerBank:(NSDictionary *)registerbankDic;
@end

@interface RegisterBankViewController : BaseViewController
{
    NSInteger _bankTypeId;
    NSInteger _districtId;
}
@property (nonatomic,assign)NSInteger bankTypeId;
@property (nonatomic,assign)NSInteger districtId;
@property (weak, nonatomic) IBOutlet UITableView *registerBankTableView;
@property (nonatomic,weak) id<RegisterBankViewControllerDelegate>delegate;
@end
