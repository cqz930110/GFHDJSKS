//
//  ChatGroup.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ChatGroupDAO.h"
#import "PSGroup.h"

@implementation ChatGroupDAO

// override 把创表的代码写入即可
+ (void)createTablesNeeded
{
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
        
        /**
         *  //项目数据
         *  @param id 主键
         *  @param loginname 用户的username
         *  @param type 类型，项目群和两天群
         *  @param groupid 唯一/查询key
         *  @param groupname 昵称
         *  @param avatar   头像
         *  @param userinfo 扩展类型
         */
        /*t_chatgroup*/
        NSString *sqlstr = @"CREATE TABLE IF NOT EXISTS t_chatgroup (id integer primary key autoincrement,type INTEGER ,loginname TEXT NOT NULL, groupid TEXT NOT NULL, groupname TEXT NOT NULL, avatar TEXT, userinfo BLOB)";
        if (![database executeUpdate:sqlstr])
        {
            NSLog(@"创建表失败");
        }
    }];
}

// ============增加/改============
+ (BOOL)updateChatGroup:(PSGroup *)chatGroup
{
    if (IsStrEmpty([self loginname])) return NO;
    if (!chatGroup || chatGroup.Id <= 0) return NO;
    
    // 判断数据
    if (!chatGroup.userInfo &&
        chatGroup.groupName.length == 0 &&
        chatGroup.avatar.length == 0) return NO;
    
    // 查询
    PSGroup *group = [self chatGroupWithGroupId:chatGroup.Id];
    if (!group)
    {
        //增加数据
        return [self insertChatGroup:group];
    }
    
    // 判断是否需要更新
    if ([chatGroup.avatar isEqualToString:group.avatar] &&
        [chatGroup.groupName isEqualToString:group.groupName] &&
        [chatGroup.userInfo isEqualToDictionary:group.userInfo]) return NO;
    
    // 更新操作
    NSString *sqlStr = @"update t_chatgroup set avatar = ?,groupname = ?,userinfo = ? where groupid = ? and loginname = ?";
    NSArray *arguments = @[chatGroup.avatar,chatGroup.groupName,[NSKeyedArchiver archivedDataWithRootObject:chatGroup.userInfo],@(chatGroup.Id),[self loginname]];
    
    __block BOOL success = NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //更新
        
        if (![db executeUpdate:sqlStr withArgumentsInArray:arguments])
        {
            *rollback = YES;
            return;
        }
        success = YES;
    }];
    return success;
}

+ (BOOL)insertChatGroup:(PSGroup *)group
{
    if (IsStrEmpty([self loginname])) return NO;
    if (!group || group.Id <= 0) return NO;
    
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  添加数据
        NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:group.userInfo];
        if (![db executeUpdateWithFormat:@"INSERT INTO t_chatgroup(type, groupid,groupname,avatar,userinfo,loginname)VALUES(%@,%@,%@,%@,%@,%@)",@(group.typeId),@(group.Id),group.groupName,group.avatar,infoData,[self loginname]])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    
    return isSuccess;
}

// =============查============
+ (NSArray *)chatGroupsWithGroupType:(NSInteger)groupType
{
    if (IsStrEmpty([self loginname])) return nil;
    // 查询语句
    if (groupType != 0 || groupType != 1) return nil;
    __block NSMutableArray *groups;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_chatgroup where type = ? and loginname = ?",@(groupType),[self loginname]];
        if(!rs)
        {
            [rs close];
            return;
        }
        groups = [NSMutableArray array];
        while ([rs next])
        {
            PSGroup *group = [[PSGroup alloc] init];
            group.Id = [rs longForColumn:@"groupid"];
            group.groupName = [rs stringForColumn:@"groupname"];
            group.avatar = [rs stringForColumn:@"avatar"];
            group.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"userinfo"]];
            [groups addObject:group];
        }
        [rs close];
    }];
    return groups;
}

+ (PSGroup *)chatGroupWithGroupId:(long)groupId
{
    if (IsStrEmpty([self loginname])) return nil;
    // 查询语句
    if (groupId <= 0) return nil;
    __block PSGroup *group;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_chatgroup where groupid = ? and loginname",@(groupId),[self loginname]];
        if(!rs)
        {
            [rs close];
            return;
        }
        
        while ([rs next])
        {
            group = [[PSGroup alloc] init];
            group.Id = [rs longForColumn:@"groupid"];
            group.groupName = [rs stringForColumn:@"groupname"];
            group.avatar = [rs stringForColumn:@"avatar"];
            group.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"userinfo"]];
            break;// 数据只有一个
        }
        
        [rs close];
        
    }];
    return group;
}

+ (NSString *)avatarWithGroupId:(long )groupId
{
   return [self chatGroupWithGroupId:groupId].avatar;
}

+ (NSString *)groupNameWithGroupId:(long )groupId
{
   return [self chatGroupWithGroupId:groupId].groupName;
}

+ (NSDictionary *)userInfoWithGroupId:(long )groupId
{
    return [self chatGroupWithGroupId:groupId].userInfo;
}

// ===========删除==============
+ (BOOL)deleteChatGroups:(NSArray *)chatGroups
{
    for (PSGroup *chatGroup in chatGroups)
    {
        if (![self deletChatGroup:chatGroup])
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)deletChatGroup:(PSGroup *)chatGroup
{
    if (!chatGroup || chatGroup.Id <= 0 ) return NO;
    
    __block BOOL success = NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *deleteSql = @"DELETE FROM t_chatgroup WHERE groupid = ? and loginname = ?";
        if (![db executeUpdate:deleteSql,@(chatGroup.Id),[self loginname]])
        {
            *rollback = YES;
            return;
        }
        success = YES;
    }];
    return success;
}

+ (NSString *)loginname
{
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    return loginUsername;
}

@end
