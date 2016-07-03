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

#import "BlackListViewController.h"

#import "BaseTableViewCell.h"

#import "EaseChineseToPinyin.h"
#import "BlackBuddy.h"

@interface BlackListViewController ()<IChatManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataSource;
}
 
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation BlackListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    self.title = @"黑名单";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = [UIColor blackColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [self backBarItem];
    [self setupHeaderRefresh:_tableView];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self reloadDataSource];
    
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BlackBuddy *blackBuddy = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.blackBuddy = blackBuddy;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BlackBuddy *blackBuddy = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.httpUtil requestDic4MethodName:@"Friend/Status" parameters:@{@"UserName":blackBuddy.userName,@"Status":@(0)} result:^(NSDictionary *dic, int status, NSString *msg)
        {
            if(status == 1 || status == 2)
            {
                [[EaseMob sharedInstance].chatManager asyncUnblockBuddy:blackBuddy.userName];
                [[self.dataSource objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            }
            else
            {
                [MBProgressHUD showError:msg toView:self.view];
            }
            
            if (self.dataSource.count == 0)
            {
                self.hideNoMsg = NO;
            }
            else
            {
                [tableView reloadData];
                self.hideNoMsg = YES;
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解除";
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Refresh delegate
//刷新列表
- (void)headerRefreshloadData
{
    [self reloadDataSource];
}

#pragma mark - data

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (BlackBuddy *blackBuddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:blackBuddy.reviewName];
        NSInteger section;
        if (firstLetter)
        {
            section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        }
        else
        {
            section = sortedArray.count - 1;
        }
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:blackBuddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(BlackBuddy *obj1, BlackBuddy *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.reviewName];
            if (IsStrEmpty(firstLetter1))
            {
                firstLetter1 = @" ";
            }
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.reviewName];
            if (IsStrEmpty(firstLetter2))
            {
                firstLetter2 = @" ";
            }
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
    
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    return sortedArray;
}

//- (void)reloadDataSource
//{
//    [_dataSource removeAllObjects];
//    [self.tableView.mj_header endRefreshing];
//    NSArray *blocked = [[EaseMob sharedInstance].chatManager fetchBlockedList:nil];
//    [_dataSource addObjectsFromArray:[self sortDataArray:blocked]];
//    [self.tableView reloadData];
//}

#pragma mark - Request
- (void)reloadDataSource
{
    [_dataSource removeAllObjects];
    [self.httpUtil requestArr4MethodName:@"Friend/BlackList" parameters:@{@"PageIndex":@(1),@"PageSize":@(1000)} result:^(NSArray *arr, int status, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        if (status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            if (arr.count)
            {
                [_dataSource addObjectsFromArray:[self sortDataArray:arr]];
                [self.tableView reloadData];
            }
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if (arr.count == 0)
        {
            self.hideNoMsg = NO;
        }
        else
        {
            self.hideNoMsg = YES;
        }
        
    } convertClassName:@"BlackBuddy" key:@"DataSet"];
}
@end
