//
//  ChatBuddyDAO.m
//  fmdb
//
//  Created by Apple on 16/4/2.
//
//

#import "ChatBuddyDAO.h"
#import "PSChat.h"
@implementation ChatBuddyDAO
+ (BOOL)updateChatBuddy:(PSChat *)chatBuddy
{

    if (!chatBuddy || IsStrEmpty(chatBuddy.value)) return NO;
    // 判断数据
    
    if (!chatBuddy.userInfo &&
        chatBuddy.showName.length == 0 &&
        chatBuddy.avatar.length == 0) return NO;
    
    // 查询
    PSChat *chatData = [self chatBuddyWithUserame:chatBuddy.value];
    if (!chatData)
    {
        //增加数据
        return [self insertChatBuddy:chatBuddy];
    }
    
    // 判断是否需要更新
    if ([chatBuddy.avatar isEqualToString:chatData.avatar] &&
        [chatBuddy.showName isEqualToString:chatData.showName] &&
        [chatBuddy.userInfo isEqualToDictionary:chatData.userInfo]) return NO;
    
    // 更新操作
    NSString *sqlStr = @"update t_chatbuddy set avatar = ?,nickname = ?,userinfo = ?,showtype = ? where username = ?";
    NSArray *arguments = @[chatBuddy.avatar,chatBuddy.showName,[NSKeyedArchiver archivedDataWithRootObject:chatBuddy.userInfo],@(chatBuddy.showType),chatBuddy.value];

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

+ (BOOL)insertChatBuddy:(PSChat *)chat
{
    if (!chat ||  IsStrEmpty(chat.value)) return NO;
//    return YES;
    __block BOOL isSuccess = NO;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  添加数据
//        NSString *insertSql = @"INSERT INTO t_chatbuddy(type, username,nickname,avatar,userinfo)VALUES(?,?,?,?,?)";
        NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:chat.userInfo];
        NSLog(@"INSERT INTO t_chatbuddy(type, username,nickname,showtype,avatar,userinfo)VALUES(%@,%@,%@,%@,%@,%@)",@(chat.type),chat.value,chat.showName,@(chat.showType),chat.avatar,infoData);
        if (![db executeUpdateWithFormat:@"INSERT INTO t_chatbuddy(type, username,nickname,showtype,avatar,userinfo)VALUES(%@,%@,%@,%@,%@,%@)",@(chat.type),chat.value,chat.showName,@(chat.showType),chat.avatar,infoData])
        {
            *rollback = YES;
            return;
        }
        isSuccess = YES;
    }];
    
    return isSuccess;
}

// ==============查==============
+ (NSString *)avatarWithUserame:(NSString *)username
{
    return [self chatBuddyWithUserame:username].avatar;
}

+ (NSString *)nicknameWithUserame:(NSString *)username
{
    return [self chatBuddyWithUserame:username].showName;
}

+ (NSDictionary *)userInfoWithUserame:(NSString *)username
{
    return [self chatBuddyWithUserame:username].userInfo;
}

+ (PSChat *)chatBuddyWithUserame:(NSString *)username
{
    // 查询语句
    if (username.length == 0) return nil;
    __block PSChat *chat;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * FROM t_chatbuddy where username = ?",username];
        if(!rs)
        {
            [rs close];
            return;
        }
        
        while ([rs next])
        {
            chat = [[PSChat alloc] init];
            chat.value = [rs stringForColumn:@"username"];
            chat.showName = [rs stringForColumn:@"nickname"];
            chat.avatar = [rs stringForColumn:@"avatar"];
            chat.showType = [[rs stringForColumn:@"showtype"] intValue];
            chat.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"userinfo"]];
            break;// 数据只有一个
        }
        
        [rs close];
        
    }];
    return chat;
}

// ===========删除==============
+ (BOOL)deleteChatBuddys:(NSArray *)chatBuddys
{
    for (PSChat *chat in chatBuddys)
    {
        if (![self deletChatBuddy:chat])
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)deletChatBuddy:(PSChat *)chatBuddy
{
    if (!chatBuddy || IsStrEmpty(chatBuddy.name)) return NO;

    __block BOOL success = NO;
    [[self databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *deleteSql = @"DELETE FROM t_chatbuddy WHERE username = ?";
        if (![db executeUpdate:deleteSql,chatBuddy.value])
        {
            *rollback = YES;
            return;
        }
        success = YES;
    }];
    return success;
}

// override 把创表的代码写入即可
+ (void)createTablesNeeded
{
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
        
        /**
         *  //项目数据
         *  @param id 主键
         *  @param type 类型，是个人还是群
         *  @param username 唯一/查询key
         *  @param nickname 昵称
         *  @param avatar   头像
         *  @param userinfo 扩展类型
         */
        /*t_chatbuddy*/
        NSString *sqlstr = @"CREATE TABLE IF NOT EXISTS t_chatbuddy (id integer primary key autoincrement,type INTEGER ,showtype INT , username TEXT NOT NULL, nickname TEXT NOT NULL, avatar TEXT, userinfo BLOB)";
        if (![database executeUpdate:sqlstr])
        {
            NSLog(@"创建表失败");
        }
        
    }];
}
@end