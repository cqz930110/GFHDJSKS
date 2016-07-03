//
//  DatabaseManager.m
//  SuningFutureStore
//
//  Created by Wang Jia on 10-10-31.
//  Copyright 2010 IBM. All rights reserved.
//

#import "DatabaseManager.h"
#include <sqlite3.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

// database dir
static NSString *const kDatabaseFileName = @"mochoujun.sqlite";
static NSString *_DatabaseDirectory;
static inline NSString* DatabaseDirectory() {
    if(!_DatabaseDirectory)
    {
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _DatabaseDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"Database"] copy];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL isExist = [fileManager fileExistsAtPath:_DatabaseDirectory isDirectory:&isDir];
        if (!isExist)
        {
            [fileManager createDirectoryAtPath:_DatabaseDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return _DatabaseDirectory;
}

//=======================================================================
@interface DatabaseManager ()
{
    BOOL _isDataBaseOpened;
}
@end

@implementation DatabaseManager
static DatabaseManager *manager = nil;

- (id)init
{
	if(self = [super init])
    {
		_isDataBaseOpened = NO;
        NSString *writablePath = [DatabaseDirectory() stringByAppendingPathComponent:kDatabaseFileName];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:writablePath];
		[self openDataBase];
	}
    return self;
}

- (BOOL)isDatabaseOpened
{
    return _isDataBaseOpened;
}

- (void)openDataBase
{
    if (!_databaseQueue)
    {
        _isDataBaseOpened = NO;
        NSLog(@"创建数据路失败");
        return;
    }
    
    _isDataBaseOpened = YES;
    NSLog(@"Open Database OK!");
    [_databaseQueue inDatabase:^(FMDatabase *db){
        [db setShouldCacheStatements:YES];
    }];
}

- (void)closeDataBase
{
	if(!_isDataBaseOpened)
    {
		NSLog(@"数据库已打开，或打开失败。请求关闭数据库失败。");
		return;
	}
	[_databaseQueue close];
	_isDataBaseOpened = NO;
	NSLog(@"关闭数据库成功。");
}

+ (DatabaseManager*)currentManager
{
    
	@synchronized(self)
    {
		if(!manager)
        {
			manager = [[DatabaseManager alloc] init];
		}
	}
	return manager;
}

-(void)dealloc
{
	[self closeDataBase];
}
@end
