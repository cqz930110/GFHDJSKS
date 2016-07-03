//
//  AddressBookUtil.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AddressBookManage.h"

@implementation AddressBookManage
#pragma mark - init
+ (AddressBookManage *)addressBookManage
{
    return [[AddressBookManage alloc]init];
}

#pragma mark - AddressBook
- (APAddressBook *)addressBook
{
    if (!_addressBook)
    {
        _addressBook = [[APAddressBook alloc] init];
        _addressBook.filterBlock = ^BOOL(APContact *contact)
        {
            return contact.phones.count > 0;
        };
        _addressBook.fieldsMask = APContactFieldDefault;
        _addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]
                                         ];
    }
    return _addressBook;
}

#pragma mark - Public
- (void)contactsJsonStrComplete:(CompleteHandle)complete
{
    [self.addressBook loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
        // 判断错误
        if (!error)
        {
            NSArray *contactDics = [self contactDicsByContacts:contacts];
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactDics options:NSJSONWritingPrettyPrinted error:&error];
            NSString *contactJsonStr= [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error)
            {
                if (complete) complete(-1,error,@"转JSON失败",nil);
            }
            else
            {
                if (complete) complete(1,nil,nil,contactJsonStr);
            }
        }
        else
        {
            // show error
            if (complete) complete(-1,error,@"读取通讯录失败",nil);
        }
    }];
}

#pragma mark - Private
- (NSMutableArray *)contactDicsByContacts:(NSArray *)contacts
{
    // 通讯录转字典
    NSMutableArray *contactDics = [NSMutableArray arrayWithCapacity:contacts.count];
    for (APContact *contact in contacts)
    {
        APPhone *phone = contact.phones[0];
        
        APName *name = contact.name;
        NSMutableString *nameStr = [NSMutableString string];
        if (name.lastName)
        {
            [nameStr appendString:name.lastName];
        }
        
        if (name.middleName)
        {
            [nameStr appendString:name.middleName];
        }
        
        if (name.firstName)
        {
            [nameStr appendString:name.firstName];
        }
        
        NSMutableDictionary *contactDic = [NSMutableDictionary dictionary];
        if (contact.recordID)
        {
            [contactDic setValue:contact.recordID forKey:@"ContentId"];
        }
        
        if (nameStr)
        {
            [contactDic setValue:nameStr forKey:@"Name"];
        }
        
        if (phone.number)
        {
            [contactDic setValue:phone.number forKey:@"Phone"];
        }
        
        [contactDics addObject:contactDic];
    }
    return contactDics;
}

@end
