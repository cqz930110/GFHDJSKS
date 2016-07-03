//
//  GroupFriendListViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "GroupFriendListViewController.h"
#import "BaseTableViewCell.h"
#import "PSBuddy.h"
#import "GroupOwnerView.h"
#import "FriendDetailViewController.h"

@interface GroupFriendListViewController ()<GroupOwnerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) PSBuddy *groupOwer;
@end

@implementation GroupFriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群成员";
    [self setupTableView];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self reloadDataSource];
}

- (void)setupTableView
{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.sectionIndexColor = [UIColor blackColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self backBarItem];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Setter & Getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}


- (void)setGroupOwer:(PSBuddy *)groupOwer
{
    _groupOwer = groupOwer;
    GroupOwnerView *view = [[[NSBundle mainBundle] loadNibNamed:@"GroupOwnerView" owner:self options:nil] lastObject];
    view.buddy = _groupOwer;
    view.delegate = self;
    self.tableView.tableHeaderView = view;
}

#pragma mark - GroupOwnerViewDelegate
- (void)gotoGroupOwnerDetail:(PSBuddy *)buddy
{
    FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
    vc.buddy = buddy;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *buddys = [_dataSource objectAtIndex:section];
    
    return buddys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *buddys = [_dataSource objectAtIndex:indexPath.section];
    PSBuddy *buddy = buddys[indexPath.row];
    cell.buddy = buddy;
    return cell;
}

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
    [contentView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSBuddy *buddy = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
    vc.buddy = buddy;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [_sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [_sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (PSBuddy *blackBuddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:blackBuddy.reviewName];
        if (IsStrEmpty(firstLetter))
        {
            firstLetter = @" ";
        }

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
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(PSBuddy *obj1, PSBuddy *obj2) {
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

#pragma mark - Request
- (void)reloadDataSource
{
    [self.httpUtil requestArr4MethodName:@"Group/UserList" parameters:@{@"GroupId":_groupId,@"PageIndex":@(1),@"PageSize":@(1000)} result:^(NSArray *arr, int status, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        if (status == 1)
        {
            [_dataSource removeAllObjects];
            [MBProgressHUD dismissHUDForView:self.view];
            if (arr.count)
            {
                NSMutableArray *members = [NSMutableArray arrayWithArray:arr];
                self.groupOwer =  members[0];
                [members removeObjectAtIndex:0];
                [self.dataSource addObjectsFromArray:[self sortDataArray:members]];
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
        
    } convertClassName:@"PSBuddy" key:@"DataSet"];
}

@end
