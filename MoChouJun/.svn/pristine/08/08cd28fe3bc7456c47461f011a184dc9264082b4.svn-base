//
//  ExpressAddresseCell.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressAddresseCell;
@class Address;
@protocol ExpressAddresseCellDelegate<NSObject>
- (void)expressAddresseCellOptionDefaultAddress:(ExpressAddresseCell *)cell;
@end
@interface ExpressAddresseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addressEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddressBtn;
@property (strong, nonatomic) Address *address;
@property (weak, nonatomic) id<ExpressAddresseCellDelegate> delegate;
@end
