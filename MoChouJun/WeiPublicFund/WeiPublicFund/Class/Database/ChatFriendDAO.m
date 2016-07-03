
//  ChatFriend.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ChatFriendDAO.h"
#import "PSBuddy.h"

@implementation ChatFriendDAO
// override 把创表的代码写入即可
+ (void)createTablesNeeded
{
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
        
        /**
         *  //项目数据
         *  @param id 主键
         *  @param loginname 登录用户名
         *  @param username 唯一/查询key
         *  @param nickname 昵称
         *  @param avatar   头像
         *  @param userinfo 扩展类型
         */
        /*t_chatfriend*/
        NSString *sqlstr = @"CREATE TABLE IF NOT EXISTS t_chatfriend (id integer primary key autoincrement, username TEXT NOT NULL, nickname TEXT NOT NULL, avatar TEXT, userinfo BLOB,loginname TEXT NOT NULL)";
        if (![database executeUpdate:sqlstr])
        {
            NSLog(@"创建表失败");
        }
    }];
}

// ============增加/改============
+ (void)updateChatFriends:(NSArray *)chatFriends
{
    for (PSBuddy *friend in chatFriends)
    {
        [self updateChatFriend:friend];
    }
}

+ (BOOL)updateChatFriend:(PSBuddy *)chatFriend
{
    if (IsStrEmpty([self loginname])) return NO;
    
    // 数据判断
    if (!chatFriend || IsStrEmpty(chatFriend.userName)) return NO;
    
    // 查询 判断
    PSBuddy *buddy = [self chatFriendWithUserame:chatFriend.userName];
    if (!buddy)
    {
        //增加数据
        return [self insertChatFriend:chatFriend];
    }
    
    // 判断是否需要更新
    if ([chatFriend.avatar isEqualToString:buddy.avatar] &&
        [chatFriend.reviewName isEqualToString:buddy.nickName] &&
        [chatFriend.userInfo isEqualToDictionary:buddy.userInfo]) return NO;
    
    // 更新操作
    NSString *sqlStr = @"update t_chatfriend set avatar = ?,nickname = ?,userinfo = ? where username = ? and loginname = ?";
    NSArray *arguments = @[chatFriend.avatar,chatFriend.reviewName,[NSKeyedArchiver archivedDataWithRootObject:chatFriend.userInfo],chatFriend.userName,[self loginname]];
    
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

+ (BOOL)insertChatFriend:(PSBuddy *)friend
{
    if (IsStrEmpty([self loginname])) return NO;
    if (!friend ||  IsStrEmpty(friend.userName)) return NO;
    
    //    return YES;
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  添加数据
        NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:friend.userInfo];
        if (![db executeUpdateWithFormat:@"INSERT INTO t_chatfriend(username,nickname,avatar,userinfo,loginname)VALUES(%@,%@,%@,%@,%@)",friend.userName,friend.reviewName,friend.avatar,infoData,[self loginname]])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    return isSuccess;
}

// =============查============
+ (NSArray *)allChatFriends
{
    // 查询语句
    __block NSMutableArray *friends;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_chatfriend where loginname = ?",[self loginname]];
        if(!rs)
        {
            [rs close];
            return;
        }
        friends = [NSMutableArray array];
        while ([rs next])
        {
            PSBuddy *friend = [[PSBuddy alloc] init];
            friend.userName = [rs stringForColumn:@"username"];
            friend.nickName = [rs stringForColumn:@"nickname"];
            friend.avatar = [rs stringForColumn:@"avatar"];
            friend.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"userinfo"]];
            
            [friends addObject:friend];
        }
        [rs close];
    }];
    return friends;
}

+ (PSBuddy *)chatFriendWithUserame:(NSString *)username
{
    // 查询语句
    if (username.length == 0) return nil;
    __block PSBuddy *friend;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_chatfriend where username = ? and loginname = ?",username,[self loginname]];
        if(!rs)
        {
            [rs close];
            return;
        }
        
        while ([rs next])
        {
            friend = [[PSBuddy alloc] init];
            friend.userName = [rs stringForColumn:@"username"];
            friend.nickName = [rs stringForColumn:@"nickname"];
            friend.avatar = [rs stringForColumn:@"avatar"];
            friend.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"userinfo"]];
            break;// 数据只有一个
        }
        
        [rs close];
        
    }];
    return friend;
}

+ (NSString *)avatarWithUserame:(NSString *)username
{
    return [self chatFriendWithUserame:username].avatar;
}

+ (NSString *)nicknameWithUserame:(NSString *)username
{
    return [self chatFriendWithUserame:username].nickName;
}

+ (NSDictionary *)userInfoWithUserame:(NSString *)username
{
    return [self chatFriendWithUserame:username].userInfo;
}

// ===========删除==============
+ (BOOL)deleteChatFriends:(NSArray *)usernames
{
    for (NSString *username in usernames)
    {
        if (![self deletChatFriendWithUsername:username])
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)deletChatFriendWithUsername:(NSString *)username
{
    if (IsStrEmpty(username)) return NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         NSString *deleteSql = @"DELETE FROM t_chatfriend WHERE username = ? and loginname = ?";
         [db executeUpdate:deleteSql,username,[self loginname]];
     }];
    return YES;
//    if ([self chatFriendWithUserame:username])
//    {
//        
//    }
//    else
//    {
//        return NO;
//    }
}

+ (BOOL)existChatFriendWithUsername:(NSString *)username
{
    //查询数据
    __block BOOL success = NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        int count = [db intForQuery:@"SELECT COUNT(*) FROM t_chatfriend WHERE username = ? and loginname",username,[self loginname]];
        if (count)
        {
            success = YES;
        }
    }];
    return success;
}

+ (NSString *)loginname
{
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    return loginUsername;
}

@end
