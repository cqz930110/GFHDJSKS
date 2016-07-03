//
//  RequestAddressUtil.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "RequestAddressUtil.h"
#import "NetWorkingUtil.h"
#import "AddressCoreDataManage.h"
#import "Contact.h"
@implementation RequestAddressUtil
static RequestAddressUtil *instance = nil;

+ (RequestAddressUtil *)shareRequestAddressUtil
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[super allocWithZone:NULL] init];
            instance.updateStatus = RequestAddressStatusNoUpdate;
        });
    } 
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareRequestAddressUtil];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

- (void)setComplete:(CompleteHandle)complete
{
    _complete = complete;
}

- (void)updateAddressBookComplete:(CompleteHandle)complete
{
    self.complete = complete;
    // 是否需要跟新
    if (![self canLoadPhoneContacts])
    {
        if (complete)
        {
            self.complete(0,nil,@"不需要更新",nil);
        }
        _updateStatus = RequestAddressStatusUpdated;
        return;
    }
    
    // 是否可以访问
    if ([APAddressBook access] != APAddressBookAccessGranted)
    {
        if (complete)
        {
            self.complete(0,nil,@"用户不同意访问你的通讯录",nil);
        }
        _updateStatus = RequestAddressStatusNoUpdate;
        return;
    }
    
    [self loadPhoneContactsCompleteHander:self.complete];
}

- (BOOL)canLoadPhoneContacts
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *loadTime = [userDefaults objectForKey:kLoadContactTime];
    if (!loadTime)
    {
        return YES;
    }
    else
    {
        NSTimeInterval time = [loadTime timeIntervalSinceDate:[NSDate date]];
        //过了一个星期 上传
        if (-time > 7 * 24 * 60 * 60)
        {
            return YES;
        }
    }
    return NO;
}

- (void)loadPhoneContactsCompleteHander:(CompleteHandle)complete
{
    _updateStatus = RequestAddressStatusUpdating;
    [[AddressBookManage addressBookManage] contactsJsonStrComplete:^(int status, NSError *error, NSString *message, id data) {
        if ([data isEqualToString:@"[\n\n]"])
        {
            self.complete(0,nil,@"无数据",nil);
            _updateStatus = RequestAddressStatusUpdated;
            return ;
            
        }
        if (data)
        {
            [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Phone/Check" parameters:@{@"Contacts":data} result:^(NSArray *arr, int status, NSString *msg)
             {
                 // 状态判段
                 if (status == 1 || status == 2)
                 {
                     //类型判断
                     if ([arr isKindOfClass:[NSArray class]])
                     {
                         // 数据库操作 ，更新保存数据
                         [self updateLocationContactWithDate:arr completeHander:complete];
                     }
                     else
                     {
                         // show error
                         if (complete)
                         {
//                             _updated = NO;
                             self.complete(0,nil,@"返回数据有误",nil);
                             _updateStatus = RequestAddressStatusUpdated;
                         }
                     }
                 }
                 else
                 {
                     if (complete)
                     {
                         _updateStatus = RequestAddressStatusUpdateFail;
                         self.complete(-1,nil,@"上传通讯录失败",nil);
                     }
                 }
             } convertClassName:nil key:nil];
        }
        else
        {
            _updateStatus = RequestAddressStatusUpdateFail;
            complete(status,error,message,nil);
        }
    }];
}

- (void)updateLocationContactWithDate:(NSArray *)data completeHander:(CompleteHandle)completeHandle
{
    // 双循环 进行对比
    AddressCoreDataManage *dataManage = [AddressCoreDataManage shareAddressCoreDataManage];
    NSArray * locContacts = [dataManage allContactsBySqLite];
    if (data.count == 0)
    {
        self.complete(0,nil,@"无数据更新",nil);
        _updateStatus = RequestAddressStatusUpdated;
        return ;
    }
    // 开启线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSError *error = nil;

        // 更新之前数据出错的问题 （删除之前的数据库数据）
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *updateState = [userDefaults objectForKey:@"updateContactBug"];
        if (IsStrEmpty(updateState))
        {
            for (Contact *contact in locContacts)
            {
                [dataManage.contactsContext deleteObject:contact];
                [dataManage.contactsContext save:nil];
            }
            
            [userDefaults setObject:@"1" forKey:@"updateContactBug"];
            [userDefaults synchronize];
        }
        
        if (!IsStrEmpty(updateState) && locContacts.count)
        {
            for (Contact *contact in locContacts)
            {
                // 数据库其中的一个
                BOOL isEqual = NO;
                
                for (NSDictionary *dic in data)
                {
                    int contentId = [[dic valueForKey:@"ContentId"] intValue];// 用于判断
                    isEqual = (contentId == [contact.contentId intValue]);
                    if (isEqual)
                    {
                        NSInteger contactStatus = [[dic valueForKey:@"StatusId"] integerValue];
                        // 跟新数据
                        contact.statusId = [NSNumber numberWithInteger:contactStatus];
                        [dataManage.contactsContext save:&error];
                        break;
                    }
                }
                
                if (!isEqual)
                {
                    // 删除数据
                    [dataManage.contactsContext deleteObject:contact];
                    [dataManage.contactsContext save:&error];
                    break;
                }
            }
            
            // new
            for (NSDictionary *dic in data)
            {
                BOOL isEqual = NO;
                int contentId = [[dic valueForKey:@"ContentId"] intValue];// 用于判断
                for (Contact *contact in locContacts)
                {
                    isEqual = (contentId == [contact.contentId intValue]);
                    if (isEqual)
                    {
                        break;
                    }
                }
                
                if (!isEqual)
                {
                    // 添加数据
                    Contact *addContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:dataManage.contactsContext];
                    if (addContact)
                    {
                        addContact.name = [dic valueForKey:@"Name"];
                        addContact.contentId = @([[dic valueForKey:@"ContentId"] integerValue]);
                        addContact.phone = [dic valueForKey:@"Phone"];
                        addContact.statusId = [dic valueForKey:@"StatusId"];
                        [dataManage.contactsContext save:&error];
                    }
                    break;
                }
            }
        }
        else
        {
            // 直接添加
            for (NSDictionary *dic  in data)
            {
                // 直接添加数据
                Contact *addContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:dataManage.contactsContext];
                NSString *urlCode = [dic valueForKey:@"Name"];                 addContact.name = [urlCode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                ;
                addContact.contentId =  @([[dic valueForKey:@"ContentId"] integerValue]);
                addContact.phone = [dic valueForKey:@"Phone"];
                addContact.statusId = [dic valueForKey:@"StatusId"];
                [dataManage.contactsContext save:&error];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                _updateStatus = RequestAddressStatusUpdated;
                if (completeHandle)
                {
                    [dataManage.contactsContext save:nil];
                    self.complete(-1,error,@"更新数据库失败",nil);
                }
            }
            else
            {
                _updateStatus = RequestAddressStatusUpdated;
                if (completeHandle)
                {
                    self.complete(1,nil,@"执行成功",nil);
                }
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSDate date] forKey:kLoadContactTime];
                [userDefaults synchronize];
            }
        });
    });
}
@end
