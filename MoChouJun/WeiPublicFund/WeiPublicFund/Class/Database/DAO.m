//
//  DAO.m
//  SuningEBuy
//
//  Created by liukun on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DAO.h"
#import "DatabaseManager.h"
static FMDatabaseQueue *databaseQueue_;
@implementation DAO
+(void)initialize
{
    databaseQueue_ = [DatabaseManager currentManager].databaseQueue;
    if (databaseQueue_) [self createTablesNeeded];
}

+ (FMDatabaseQueue *)databaseQueue
{
    if (![[DatabaseManager currentManager] isDatabaseOpened]) {
        [[DatabaseManager currentManager] openDataBase];
        databaseQueue_ = [DatabaseManager currentManager].databaseQueue;
    }
    return databaseQueue_;
}

// override
+ (void)createTablesNeeded
{
    
}

@end