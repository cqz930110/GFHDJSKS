//
//  AddExpressAddressViewController.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
@class Address;
@protocol AddExpressAddressViewControllerDelegate<NSObject>
- (void)callbackAddAdressId:(NSInteger)addressId;
@end
@interface AddExpressAddressViewController : BaseViewController
{
    NSString *_type;
}
@property (nonatomic,strong)NSString *type;
//@property (assign, nonatomic) BOOL showBackItem;
@property (weak, nonatomic) id<AddExpressAddressViewControllerDelegate> delegate;
@property (strong, nonatomic) Address *address;
@end
