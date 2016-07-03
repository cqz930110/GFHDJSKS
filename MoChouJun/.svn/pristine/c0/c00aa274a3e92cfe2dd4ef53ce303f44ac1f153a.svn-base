//
//  ProjectDAO.m
//  fmdb
//
//  Created by Apple on 16/3/26.
//
//

#import "ProjectDAO.h"
#import "Project.h"

@implementation ProjectDAO

// 添加首页最新的三条project

+ (BOOL)addNewestProejcts:(NSArray *)projects
{
    return [self addProjects:projects type:0];
}

// 添加首页projects 10条
+ (BOOL)addHomeProejcts:(NSArray *)projects
{
    return [self addProjects:projects type:1];
}

// 添加微众筹projects 10条
+ (BOOL)addWeiPublicFundProejcts:(NSArray *)projects
{
    return [self addProjects:projects type:2];
}

// 首页最新的三条project
+ (NSArray *)projectsAllNewest
{
    return [self projectsAllType:0];
}

// 首页首页projects 10条
+ (NSArray *)projectsAllHome
{
    return [self projectsAllType:1];
}

// 首页微众筹projects 10条
+ (NSArray *)projectsAllWeiPublicFund
{
    return [self projectsAllType:2];
}

+ (BOOL)addProjects:(NSArray *)projects type:(NSUInteger)type
{
    if (projects.count == 0) return NO;
    // 0 1 2
    __block BOOL isSuccess = NO;
    
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSNumber *typeNum = [NSNumber numberWithUnsignedInteger:type];
        
        NSUInteger count = 0;
        if (type == 2)
        {
            //查询数据
            count = [db intForQuery:@"SELECT COUNT(*) FROM t_project WHERE type = ?",typeNum];
        }
        
        // 删除数据
        if (count >= 10 || count == 0)
        {
            NSString *deleteSql = @"DELETE FROM t_project WHERE type = ?";
            if (![db executeUpdate:deleteSql,typeNum])
            {
                *rollback = YES;
                return;
            }
        }
        //  添加数据
        NSString *insertSql = @"INSERT INTO t_project(type, project)VALUES(?,?)";
        for (Project *project in projects)
        {
            
            if (![db executeUpdate:insertSql,typeNum,[NSKeyedArchiver archivedDataWithRootObject:project]])
            {
                *rollback = YES;
                return;
            }
        }
        isSuccess = YES;
    }];
    
    return isSuccess;
}

+ (NSArray *)projectsAllType:(NSUInteger)type
{
    __block NSMutableArray *array = nil;
    
    [self.databaseQueue inDatabase:^(FMDatabase *db){
        NSString *sql = @"SELECT project FROM t_project WHERE type = ? ORDER BY id ASC";
        FMResultSet *rs = [db executeQuery:sql,@(type)];
        if(!rs){
            [rs close];
            return;
        }
        array = [NSMutableArray arrayWithCapacity:10];
        while ([rs next]) {
            NSData *data = [rs dataForColumn:@"project"];
            Project *project = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [array addObject:project];
        }
        
        [rs close];
    }];
    return array;
}

// override 把创表的代码写入即可
+ (void)createTablesNeeded
{
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollBack){
        
        /**
         *  //项目数据
         *  @param id 主键
         *  @param project 项目数据 字典
         *  @param type 项目类型
         *  0 代表 news  3条
         *  1 代表首页    10条
         *  2 代表微众筹  10条
         */
        /*t_project*/
        NSString *sqlstr = @"CREATE TABLE IF NOT EXISTS t_project (id integer primary key autoincrement, project BLOB NOT NULL, type INTEGER NOT NULL)";
        [database executeUpdate:sqlstr];//  autoincrement
        
    }];
}
@end
