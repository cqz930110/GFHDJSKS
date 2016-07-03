//
//  AddressBookUtil.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APAddressBook.h>
#import "APContact.h"

typedef void(^CompleteHandle)(int status,NSError *error,NSString *msg,id data);

@class AddressBookManage;
@interface AddressBookManage : NSObject
// APAddressBook
@property (nonatomic, strong) APAddressBook *addressBook;
+ (AddressBookManage *)addressBookManage;

- (void)contactsJsonStrComplete:(CompleteHandle)complete;
@end
