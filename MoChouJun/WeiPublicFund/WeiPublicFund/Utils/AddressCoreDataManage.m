//
//  AddressCoreDataManage.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AddressCoreDataManage.h"
@interface AddressCoreDataManage ()
@property (strong, nonatomic) NSManagedObjectModel *contenteModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *contentStore;
@end

@implementation AddressCoreDataManage
static AddressCoreDataManage *instance = nil;

+ (AddressCoreDataManage *)shareAddressCoreDataManage
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[super allocWithZone:NULL] init];
        });
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareAddressCoreDataManage];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

#pragma mark - Public
- (NSArray *)allContactsBySqLite
{
    //1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    // 4.执行请求
    NSError *error = nil;
    NSArray *emps = [self.contactsContext executeFetchRequest:request error:&error];
    if (error)
    {
        return nil;
    }
    return emps;
}

- (NSArray *)allContactsSortByName
{
    // 1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    // 3.设置排序
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[heigtSort];
    // 4.执行请求
    NSError *error = nil;
    NSArray *contacts = [self.contactsContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error");
    }
    return contacts;
}

#pragma mark - Setter & Getter
- (NSManagedObjectModel *)contenteModel
{
    if (!_contenteModel)
    {
        NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Contact" withExtension:@"momd"];
        if (modelURL)
        {
            _contenteModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        }
        else
        {
            _contenteModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        }
    }
    return _contenteModel;
}

- (NSPersistentStoreCoordinator *)contentStore
{
    if (!_contentStore)
    {
        _contentStore = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.contenteModel];
        NSError *error = nil;
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlitePath = [documentPath stringByAppendingPathComponent:@"contact.sqlite"];
        [_contentStore addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
        if (error) {
            NSLog(@"初始化持久化调度器失败！%@",[error localizedDescription]);
        }
        
    }
    return _contentStore;
}


- (NSManagedObjectContext *)contactsContext
{
    if (!_contactsContext)
    {
        _contactsContext = [[NSManagedObjectContext alloc]init];
        _contactsContext.persistentStoreCoordinator = self.contentStore;
    }
    return _contactsContext;
}


@end
