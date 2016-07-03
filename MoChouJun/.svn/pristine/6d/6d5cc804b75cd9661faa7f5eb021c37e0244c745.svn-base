//
//  ExpressAddressViewController.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
@class Address;
typedef NS_ENUM(NSInteger,ExpressAddressClikeType)
{
    ExpressAddressClikeTypeEditAddress,
    ExpressAddressClikeTypeBack
};
@protocol ExpressAddressViewControllerDelegate <NSObject>

- (void)optionExpressAddress:(Address *)address;

@end

@interface ExpressAddressViewController : BaseViewController
@property (nonatomic , assign) ExpressAddressClikeType clikeType;
@property (nonatomic , weak) id<ExpressAddressViewControllerDelegate> delegate;
@end
