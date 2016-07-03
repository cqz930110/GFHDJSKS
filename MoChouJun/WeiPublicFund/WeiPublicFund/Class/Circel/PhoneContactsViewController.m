//
//  PhoneContactsViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "PhoneContactsViewController.h"
#import <CoreData/CoreData.h>
#import "Contact.h"
#import "AppDelegate.h"
#import "PhoneContactCell.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "RealtimeSearchUtil.h"
#import "FriendDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "AddressCoreDataManage.h"
#import "RequestAddressUtil.h"
@interface PhoneContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate,PhoneContactCellDelegate,MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic,strong) MFMessageComposeViewController *vc;
@end

@implementation PhoneContactsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"手机通讯录";

    RequestAddressUtil *util = [RequestAddressUtil shareRequestAddressUtil];

    if (util.updateStatus == RequestAddressStatusUpdated)
    {
       [self reloadData];
    }
    else if (util.updateStatus == RequestAddressStatusUpdating)
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        util.complete = ^(int status,NSError *error,NSString *msg,id data)
        {
            if (status == 1)
            {
                [MBProgressHUD dismissHUDForView:self.view];
                [self reloadData];
            }
            else
            {
                [MBProgressHUD dismissHUDForView:self.view withError:@"暂时数据"];
                self.hideNoMsg = NO;
            }
        };
    }
    else if (util.updateStatus == RequestAddressStatusUpdateFail)
    {
         self.hideNoMsg = NO;
    }
}

- (void)reloadData
{
    _contacts = [[AddressCoreDataManage shareAddressCoreDataManage] allContactsSortByName];
    self.dataSource = [self sortDataArray:_contacts];
    if (self.dataSource.count)
    {
        [self setupTabelView];
        [self searchController];
        [self.view addSubview:self.searchBar];
    }
    else
    {
        self.hideNoMsg = NO;
    }
}

- (void)setupTabelView
{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneContactCell" bundle:nil] forCellReuseIdentifier:@"PhoneContactCell"];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self performSelector:@selector(delayMethod:) withObject:nil afterDelay:3];
}

- (void)delayMethod:(MFMessageComposeViewController *)controller
{
    [_vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PhoneContactCellDelegate
- (void)phoneContactCellInvite:(PhoneContactCell *)cell
{
    //邀请好友
    if ([MFMessageComposeViewController canSendText])
    {
        
        _vc = [[MFMessageComposeViewController alloc]init];
        [[_vc navigationBar] setBarTintColor:[UIColor blackColor]];

        _vc.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        [_vc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _vc.recipients = @[cell.contact.phone];
        _vc.body = @"我正在使用陌筹君APP，陌筹君可以发起众筹，参与项目支持，还可以和小伙伴们聊天互动哦，快来发布属于你的众筹项目吧，亲爱的小伙伴们快来和我一起加入陌筹君吧！http://www.mochoujun.com/download";
        _vc.messageComposeDelegate = self;;
        [self presentViewController:_vc animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showMessag:@"设备不支持发送短信功能" toView:self.view];
    }
}

- (void)phoneContactCellAdd:(PhoneContactCell *)cell
{
    // 进入陌生人详情页 
    FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
    vc.friendDetailType = FriendDetailTypeUnBuddy;
    vc.searchMobile = cell.contact.phone;
    [self.navigationController pushViewController:vc animated:YES];
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
    PhoneContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneContactCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Contact *contact = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.contact = contact;
    cell.delegate = self;
    return cell;
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
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    [contentView setBackgroundColor:[UIColor colorWithHexString:@"#EBEAF1"]];
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

#pragma mark - Setter & Getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BlackF6F6F6;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = [NSMutableArray arrayWithCapacity:27];
    }
    return  _sectionTitles;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = BlackF6F6F6;
        _searchBar.tintColor = [UIColor blackColor];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PhoneContactCell" bundle:nil] forCellReuseIdentifier:@"PhoneContactCell"];
        __weak PhoneContactsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            PhoneContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneContactCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Contact *contact = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.delegate = weakSelf;
            cell.contact = contact;
            return cell;
        }];
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
    }

    return _searchController;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCancelButtonTitle:@"确定"];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:_contacts searchText:searchText collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.editing = YES;
}


#pragma mark - DataSort
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
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
    for (Contact *contact in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:contact.name];
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
        [array addObject:contact];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(Contact *obj1, Contact *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.name];
            if (IsStrEmpty(firstLetter1))
            {
                firstLetter1 = @" ";
            }

            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.name];
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
//    NSLog(@"%zd",[sortedArray count] - 1);
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    return sortedArray;
}

@end
