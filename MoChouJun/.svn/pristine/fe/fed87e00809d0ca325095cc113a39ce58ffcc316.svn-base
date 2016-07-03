//
//  AddressCoreDataManage.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface AddressCoreDataManage : NSObject
// CoreDate
@property (strong, nonatomic) NSManagedObjectContext *contactsContext;

+ (AddressCoreDataManage *)shareAddressCoreDataManage;

- (NSArray *)allContactsBySqLite;
- (NSArray *)allContactsSortByName;

@end
