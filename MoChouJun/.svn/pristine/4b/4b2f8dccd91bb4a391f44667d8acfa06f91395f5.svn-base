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

#import "GroupListViewController.h"

#import "EMSearchBar.h"
#import "BaseTableViewCell.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "RealtimeSearchUtil.h"
#import "PSBarButtonItem.h"
#import <MJRefresh.h>
#import "NetWorkingUtil.h"
#import "PSGroup.h"
#import "NoMsgView.h"
#import "ContactSelectionViewController.h"
#import "PSBuddy.h"
#import "SendCMDMessageUtil.h"
@interface GroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, IChatManagerDelegate,EMChooseViewDelegate>
{
    NetWorkingUtil *_httpUtil;
    BOOL _isProjectGroup;
}
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) NoMsgView *noDataView;
@end

@implementation GroupListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _httpUtil = [NetWorkingUtil netWorkingUtil];
    [self setupTableView];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self searchController];
    
    [MBProgressHUD showStatus:nil toView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRefreshloadData];
}

- (void)setupTableView
{
    if (_groupType)
    {
        self.title = @"项目组";
        _isProjectGroup = YES;
    }
    else
    {
        self.title = @"群聊列表";
        _isProjectGroup = NO;
        
        PSBarButtonItem *createGroupItem = [PSBarButtonItem itemWithTitle:@"发起群聊" barStyle:PSNavItemStyleDone target:self action:@selector(createGroup)];
        self.navigationItem.rightBarButtonItem = createGroupItem;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    // 上下啦
    [self setupHeaderRefresh:self.tableView];
    
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)createGroup
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Refresh
- (void)setupHeaderRefresh:(UITableView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshloadData)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"拉拉阿么就有啦\(^o^)/~" forState:MJRefreshStateIdle];
    [header setTitle:@"刷得好疼，快放开阿么 ::>_<:: " forState:MJRefreshStatePulling];
    [header setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
    tableView.mj_header = header;
}

- (void)headerRefreshloadData
{
    [self reloadDataSource];
}

#pragma mark - Getter & Setter
- (NoMsgView *)noDataView
{
    if (!_noDataView)
    {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:@"NoMsgView" owner:self options:nil] lastObject];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        
        [self.view addSubview:_noDataView];;
    }
    return _noDataView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
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
        
        __weak GroupListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            PSGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.group = group;
//            NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//            cell.imageView.image = [UIImage imageNamed:imageName];
//            cell.textLabel.text = group.groupSubject;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            PSGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *groupId = group.easemobGroupId;
            ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:groupId
                                                                                conversationType:eConversationTypeGroupChat];
            chatVC.title = group.groupName;
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    if (selectedSources.count == 1)
    {
        PSBuddy *buddy = [selectedSources firstObject];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:buddy.userName
                                                                                    conversationType:eConversationTypeChat];
        chatController.title = buddy.reviewName;
        chatController.isProjectChat = NO;
        UINavigationController *navi = self.navigationController;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [navi pushViewController:chatController animated:YES];
        return YES;
    }
    
    [MBProgressHUD showStatus:@"创建群组..." toView:self.view];
    NSMutableString *source = [NSMutableString string];
    NSMutableString *applyMessage = [NSMutableString string];
    for (PSBuddy *buddy in selectedSources) {
        NSString *username = [@"," stringByAppendingString:buddy.userName];
        [source appendString:username];
        
        NSString *name = IsStrEmpty(buddy.nickName)?buddy.userName:buddy.nickName;
        [applyMessage appendString:[@"、" stringByAppendingString:name]];
    }
    [source replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    [applyMessage replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"Group/Add" parameters:@{@"FriendNameList":source} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             [MBProgressHUD dismissHUDForView:self.view];
             [self gotoGroupConversation:dic applyMessage:applyMessage];
             [MBProgressHUD showSuccess:@"恭喜你创立了群组(* ￣3)" toView:nil];
         }
         else
         {
             [MBProgressHUD dismissHUDForView:self.view withError:@"群组创建失败"];
         }
     }];
    return YES;
}

- (void)gotoGroupConversation:(NSDictionary *)groupUserInfo applyMessage:(NSString *)message
{
    UINavigationController *navi = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    NSString *groupId = [NSString stringWithFormat:@"%@",[groupUserInfo valueForKey:@"GroupId"]];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:groupId
                                                                      conversationType:eConversationTypeGroupChat];
    chatController.title = [groupUserInfo valueForKey:@"GroupName"];
    chatController.isProjectChat = NO;
    [SendCMDMessageUtil sendGroupApplyMessageGroupId:groupId message:message];
    [navi pushViewController:chatController animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageView.layer.cornerRadius = 10;
        cell.imageView.layer.masksToBounds = YES;
    }
    PSGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    cell.group = group;
//    NSString *imageName = @"group_header";
//    cell.imageView.image = [UIImage imageNamed:imageName];
//    cell.textLabel.text = group.groupName;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PSGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    NSString *groupId = group.easemobGroupId;
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:groupId
                                                                                conversationType:eConversationTypeGroupChat];
    chatController.title = group.groupName;
    chatController.isProjectChat = _isProjectGroup;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(groupName) resultBlock:^(NSArray *results) {
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

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error) {
        [self reloadDataSource];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - data
//
//- (void)reloadDataSource
//{
//    [self.dataSource removeAllObjects];
//    
//    NSArray *rooms = [[EaseMob sharedInstance].chatManager groupList];
//    [self.dataSource addObjectsFromArray:rooms];
//    
//    [self.tableView reloadData];
//    
//    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
//        if (!error) {
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:groups];
//            [self.tableView reloadData];
//        }
//        
//    } onQueue:nil];
//    [self.tableView.mj_header endRefreshing];
//}

- (void)reloadDataSource
{
    //Type   0聊天群     1项目群
    [_httpUtil requestArr4MethodName:@"Group/List" parameters:@{@"PageIndex":@(1),@"PageSize":@(1000),@"Type":@(_groupType)} result:^(NSArray *arr, int status, NSString *msg)
    {
        [self.tableView.mj_header endRefreshing];
        if (status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if (self.dataSource.count != 0)
        {
            [self.tableView reloadData];
        }
        
        if (self.dataSource.count == 0)
        {
            self.noDataView.hidden = NO;
        }
        else
        {
            self.noDataView.hidden = YES;
        }
        
    } convertClassName:@"PSGroup" key:@"DataSet"];
}

@end
