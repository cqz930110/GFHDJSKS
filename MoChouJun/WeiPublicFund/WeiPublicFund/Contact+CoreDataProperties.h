//
//  Contact+CoreDataProperties.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/14.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *contentId;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *statusId;

@end

NS_ASSUME_NONNULL_END
