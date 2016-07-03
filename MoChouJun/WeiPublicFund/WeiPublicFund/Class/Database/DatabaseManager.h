//
//  DatabaseManager.h
//  SuningFutureStore
//
//  Created by Wang Jia on 10-10-31.
//  Copyright 2010 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface DatabaseManager : NSObject
@property (nonatomic, strong , readonly) FMDatabaseQueue *databaseQueue;
+ (DatabaseManager*)currentManager;
// isOpen
- (BOOL)isDatabaseOpened;
//打开数据库
- (void)openDataBase;
//关闭数据库
- (void)closeDataBase;
@end
