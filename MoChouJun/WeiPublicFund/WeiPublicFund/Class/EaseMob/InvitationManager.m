/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "InvitationManager.h"
#import <YYModel.h>
@implementation InvitationManager

+ (BOOL)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username
{
    if (!applyEntity || IsStrEmpty(username)) return NO;
    // 查询
    ApplyEntity *apply = [self applyEntity:applyEntity loginUser:username];
    if (!apply)
    {
        //增加数据
        return [self insertApplyEntity:applyEntity loginUser:username];
    }
    
    // 更新数据
    return [self updateApplyEntiry:applyEntity loginUser:username];
}

+ (ApplyEntity *)applyEntity:(ApplyEntity *)applyEntity loginUser:(NSString *)username
{
    // 查询语句
    if (!applyEntity || IsStrEmpty(username)) return nil;
    
    NSString *searchKey = IsStrEmpty(applyEntity.groupId)?applyEntity.applicantUsername:applyEntity.groupId;
    
    __block ApplyEntity *apply;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_applyentity where loginname = ? and searchkey = ?",username,searchKey];
        if(!rs)
        {
            [rs close];
            return;
        }
        
        while ([rs next])
        {
            NSData *data = [rs dataForColumn:@"applyentity"];
            apply = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            break;// 数据只有一个
        }
        
        [rs close];
    }];
    return apply;
}

+ (BOOL)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username
{
    if (!applyEntity || IsStrEmpty(username)) return NO;
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 删除数据
        NSString *searchKey = IsStrEmpty(applyEntity.groupId)?applyEntity.applicantUsername:applyEntity.groupId;
        
        NSString *deleteSql = @"DELETE FROM t_applyentity WHERE loginname = ? and searchkey = ?";
        if (![db executeUpdate:deleteSql,username,searchKey])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    return isSuccess;
}

+ (BOOL)removeInvitationBuddyName:(NSString *)buddyName loginUser:(NSString *)username
{
    if (IsStrEmpty(buddyName) || IsStrEmpty(username)) return NO;
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 删除数据
        NSString *deleteSql = @"DELETE FROM t_applyentity WHERE loginname = ? and searchkey = ?";
        if (![db executeUpdate:deleteSql,username,buddyName])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    return isSuccess;
}

+ (NSArray *)applyEmtitiesWithloginUser:(NSString *)username
{
    if (IsStrEmpty(username)) return nil;
    __block NSMutableArray *applyEntitys;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_applyentity where loginname = ?",username];
        if(!rs)
        {
            [rs close];
            return;
        }
        applyEntitys = [NSMutableArray array];
        while ([rs next])
        {
            NSData *data = [rs dataForColumn:@"applyentity"];
            ApplyEntity *applyEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [applyEntitys addObject:applyEntity];
        }
        
        [rs close];
    }];
    return applyEntitys;
}

+ (BOOL)updateApplyEntiry:(ApplyEntity *)applyEntity loginUser:(NSString *)username
{
    if (!applyEntity || IsStrEmpty(username)) return NO;
    __block BOOL success = NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //更新
        NSString *searchKey = IsStrEmpty(applyEntity.groupId)?applyEntity.applicantUsername:applyEntity.groupId;
        NSData *applyData = [NSKeyedArchiver archivedDataWithRootObject:applyEntity];
        if (![db executeUpdate:@"update t_applyentity set applyentity = ? where loginname = ? and searchkey = ?" withArgumentsInArray:@[applyData,username,searchKey]])
        {
            *rollback = YES;
            return;
        }
        success = YES;
    }];
    return success;
}



+ (BOOL)insertApplyEntity:(ApplyEntity *)applyEntity loginUser:(NSString *)username
{
    if (!applyEntity || IsStrEmpty(username)) return NO;
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  添加数据
        NSData *applyData = [NSKeyedArchiver archivedDataWithRootObject:applyEntity];
        NSString *searchKey = IsStrEmpty(applyEntity.groupId)?applyEntity.applicantUsername:applyEntity.groupId;
        if (![db executeUpdateWithFormat:@"INSERT INTO t_applyentity (applyentity, loginname,searchkey)VALUES(%@,%@,%@)",applyData,username,searchKey])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    
    return isSuccess;
}

// override 把创表的代码写入即可
+ (void)createTablesNeeded
{
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
        
        /**
         *  //项目数据
         *  @param id 主键
         *  @param applyentity 申请数据
         *  @param loginname 用户名称
         *  @param searchkey 搜索字段（群id 或则是 username）
         */
        /*t_applyentity*/
        NSString *sqlstr = @"CREATE TABLE IF NOT EXISTS t_applyentity (id integer primary key autoincrement,loginname text not null, applyentity BLOB NOT NULL, searchkey text NOT NULL)";
        [database executeUpdate:sqlstr];
        
    }];
}
@end

@interface ApplyEntity ()<NSCoding>

@end

@implementation ApplyEntity
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
@end

