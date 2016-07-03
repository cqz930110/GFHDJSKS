//
//  AddReturnViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class AddReturnViewController;
@protocol AddReturnViewControllerDelegate <NSObject>

- (void)addReturnSavedReturnUserInfo:(NSDictionary *)userInfo isEdit:(BOOL)isEdit;
@end

@interface AddReturnViewController : BaseViewController
@property (nonatomic,strong)NSDictionary *editReturnDic;
@property (weak, nonatomic) id<AddReturnViewControllerDelegate> delegate;
@end
