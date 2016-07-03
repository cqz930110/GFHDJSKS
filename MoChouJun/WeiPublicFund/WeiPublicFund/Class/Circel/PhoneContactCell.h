//
//  PhoneContactCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/15.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@class PhoneContactCell;
@protocol PhoneContactCellDelegate<NSObject>
- (void)phoneContactCellInvite:(PhoneContactCell*)cell;
- (void)phoneContactCellAdd:(PhoneContactCell*)cell;
@end

@interface PhoneContactCell : UITableViewCell
@property (strong, nonatomic) Contact *contact;
@property (weak, nonatomic) id<PhoneContactCellDelegate> delegate;
@end
