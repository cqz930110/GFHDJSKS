//
//  ContactListViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ContactListViewController.h"
#import "ChatViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"
#import "PSBarButtonItem.h"
#import "BaseViewController.h"
#import "BlackListViewController.h"
#import "FriendDetailViewController.h"
#import "NetWorkingUtil.h"
#import "PSBuddy.h"
#import "PSActionSheet.h"
//#import "ChatFriendDAO.h"
#import "ChatBuddyDAO.h"
#import "TongXunLuCommonTableViewCell.h"
#import "AddPopoverView.h"
#import "ContactSelectionViewController.h"
#import "GroupListsViewController.h"
#import "SendCMDMessageUtil.h"
#import "User.h"
#import "NSString+Adding.h"

@implementation EMBuddy (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.username];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate,AddPopverViewDelegate,EMChooseViewDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) AddPopoverView *popView;
@end

@implementation ContactListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavi];
    self.showRefreshHeader = NO;
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    [self searchController];
    self.tableView.tableHeaderView = self.searchBar;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TongXunLuCommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"TongXunLuCommonTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self requestUpdateFirendList];
    [self reloadApplyView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_popView.height)
    {
        [_popView showAnimation];
    }
    [super viewWillDisappear:animated];
}

- (void)requestUpdateFirendList
{
    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/List" parameters:@{@"PageIndex":@1,@"PageSize":@1000} result:^(NSArray *arr, int status, NSString *msg)
     {
         if (status == 1)
         {
             [_contactsSource removeAllObjects];
             [_contactsSource addObjectsFromArray:arr];
             [self _sortDataArray:self.contactsSource];
         }
         else
         {
             if (![msg isEqualToString:@"操作成功"])
             {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }
     } convertClassName:@"PSBuddy" key:@"DataSet"];
}

- (void)setupNavi
{
    self.title = @"通讯录";
//    self.navigationItem.rightBarButtonItem = [PSBarButtonItem itemWithImageName:@"phoneAdd" highLightImageName:nil selectedImageName:nil target:self action:@selector(phoneAdd)];
    self.navigationItem.rightBarButtonItem = [PSBarButtonItem itemWithTitle:@"添加 " barStyle:PSNavItemStyleDone target:self action:@selector(phoneAdd)];
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - Action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

- (void)phoneAdd
{
//    AddFriendViewController *vc = [[AddFriendViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [_searchController setActive:NO animated:YES];
    //    [_searchCrowdFundArr removeAllObjects];
    [_searchBar resignFirstResponder];
    [self.popView showAnimation];
}

- (AddPopoverView *)popView
{
    if (!_popView)
    {
        _popView = [[[NSBundle mainBundle] loadNibNamed:@"AddPopoverView" owner:self options:nil] lastObject];
        CGRect popViewRect = _popView.frame;
        popViewRect.origin.x = SCREEN_WIDTH - 5 - _popView.frame.size.width;
        popViewRect.origin.y = 2;
        popViewRect.size.height = 0.0;
        _popView.frame = popViewRect;
        [self.view addSubview:_popView];
        _popView.delegate = self;
    }
    return _popView;
}

#pragma mark - AddPopoverViewDelegate
- (void)addPopoverView:(AddPopoverView *)popView addActionType:(AddActionType)addActionType
{
    if (addActionType == AddActionTypeFriend)
    {
        AddFriendViewController *vc = [[AddFriendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
        selectionController.delegate = self;
        [self.navigationController pushViewController:selectionController animated:YES];
    }
}

// 添加群聊 选择联系人的回调
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
    NSMutableString *source1 = [NSMutableString string];
    NSMutableString *applyMessage = [NSMutableString string];
    for (PSBuddy *buddy in selectedSources) {
        NSString *username = [@"," stringByAppendingString:buddy.userName];
        [source appendString:username];
        NSString *niceName = [@"," stringByAppendingString:buddy.nickName];
        [source1 appendString:niceName];
        NSString *name = IsStrEmpty(buddy.nickName)?buddy.userName:buddy.nickName;
        [applyMessage appendString:[@"、" stringByAppendingString:name]];
    }
    NSString *myUserName = [@"," stringByAppendingString:[User shareUser].userName];
    [source appendString:myUserName];
    NSString *myNickName = [@"," stringByAppendingString:[User shareUser].nickName];
    [source1 appendString:myNickName];
    [applyMessage replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    [source replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    [source1 replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"Group/Add" parameters:@{@"FriendNameList":source,@"GroupName":source1} result:^(NSDictionary *dic, int status, NSString *msg)
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
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    NSString *groupId = [NSString stringWithFormat:@"%@",[groupUserInfo valueForKey:@"GroupId"]];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:groupId
                                                                                conversationType:eConversationTypeGroupChat];
    chatController.title = [groupUserInfo valueForKey:@"GroupName"];
    chatController.isProjectChat = NO;
    [SendCMDMessageUtil sendGroupApplyMessageGroupId:groupId message:message];
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - getter
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索群组/好友";
        _searchBar.backgroundColor = BlackF6F6F6;
        _searchBar.tintColor = [UIColor blackColor];
    }
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil)
    {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            PSBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.buddy = buddy;
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            PSBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.userName]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:buddy.userName
                                                                                conversationType:eConversationTypeChat];
            chatVC.title = buddy.nickName;
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = self.dataArray.count;
    if (count)
    {
        [self.noMsgView removeFromSuperview];
        return count + 1;
    }
    else
    {
        self.noMsgView.frame = CGRectMake(0,44*3 + 18, SCREEN_WIDTH, SCREEN_HEIGHT - 44*3 - 18);
        [self.tableView addSubview:self.noMsgView];
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"TongXunLuCommonTableViewCell";
        TongXunLuCommonTableViewCell *cell = (TongXunLuCommonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[TongXunLuCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0)
        {
            cell.titleLab.text = @"新的好友";
            if (_unapplyCount == 0) {
                cell.numberLab.hidden = YES;
            }else{
                NSString *countStr = [NSString stringWithFormat:@"%ld",(long)_unapplyCount];
                if (_unapplyCount > 100) {
                    cell.numberLab.width =  [countStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedSize:CGSizeMake(SCREEN_WIDTH, 18)].width;
                }
                cell.numberLab.hidden = NO;
                cell.numberLab.text = countStr;
            }
        }
        else if (indexPath.row == 1)
        {
            cell.numberLab.hidden = YES;
            cell.titleLab.text = @"群组列表";
        }
        return cell;
    }
    else
    {
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        PSBuddy *model = [userSection objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.buddy = model;
        return cell;
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BlackF6F6F6;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.textColor = Black575757;
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_popView.height)
    {
        [_popView showAnimation];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0)
    {
        if (row == 0)
        {
            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
        }
        else if (row == 1)
        {
            if (_groupController == nil)
            {
                _groupController = [GroupListsViewController new];
                _groupController.groupType = 1;
            }
            else
            {
                [_groupController reloadDataSource];
            }
            [self.navigationController pushViewController:_groupController animated:YES];
        }
//        else if (row == 2)
//        {
//            BlackListViewController *blakc = [[BlackListViewController alloc]init];
//            [self.navigationController pushViewController:blakc animated:YES];
//        }
    }
    else
    {
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        PSBuddy *model = [userSection objectAtIndex:indexPath.row];
        FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
        vc.friendDetailType = FriendDetailTypeBuddy;
//        vc.userId = [NSString stringWithFormat:@"%ld",model.userId];
        vc.buddy = model;
        [self.navigationController pushViewController:vc animated:YES];
//        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//        if (loginUsername && loginUsername.length > 0) {
//            if ([loginUsername isEqualToString:model.buddy.username]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                [alertView show];
//                
//                return;
//            }
//        }
//        NSLog(@"%@",model.buddy.username);
//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy.username conversationType:eConversationTypeChat];
//        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy.username;
//        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        PSBuddy *buddy = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([buddy.userName isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        [self.httpUtil requestDic4MethodName:@"Friend/Delete" parameters:@{@"UserName":buddy.userName} result:^(NSDictionary *dic, int status, NSString *msg)
        {
            if (status == 1 ||  status == 2)
            {
                [self.contactsSource removeObject:buddy];
                NSMutableArray *sectionArr = [self.dataArray objectAtIndex:(indexPath.section - 1)];
                if (sectionArr.count == 1)
                {
                    
                    if (self.contactsSource.count == 0)
                    {
                        [self.dataArray removeAllObjects];
                        [self.sectionTitles removeAllObjects];
                        [tableView reloadData];
                    }
                    else
                    {

                        [self.dataArray removeObjectAtIndex:indexPath.section - 1];
                        [self.sectionTitles removeObjectAtIndex:indexPath.section - 1];
    
                        [tableView reloadData];
                    }
                }
                else
                {
                    [tableView beginUpdates];
                    [sectionArr removeObjectAtIndex:indexPath.row];
                    [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [tableView  endUpdates];
                }
                
                // 删除联系人
                EMError *error = nil;
                [[EaseMob sharedInstance].chatManager removeBuddy:buddy.userName removeFromRemote:YES error:&error];
                if (!error)
                {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.userName deleteMessages:YES append2Chat:YES];
                }
//                [ChatFriendDAO deletChatFriendWithUsername:<#(NSString *)#>]
            }
            else
            {
                [MBProgressHUD showError:msg toView:self.view];
                [tableView reloadData];
            }
        }];
    }
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_popView.height>0)
    {
        [_popView showAnimation];
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(nickName) resultBlock:^(NSArray *results) {
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

#pragma mark - BaseTableCellDelegate
- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1)
    {
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    _currentLongPressIndex = indexPath;
    PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - Private Data
- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [_contactsSource mutableCopy];
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    //按首字母分组
    for (PSBuddy *buddy in contactsSource)
    {
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:buddy.reviewName];
        NSInteger section;
        if(!IsStrEmpty(firstLetter))
        {
            
             section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        }
        else
        {
            section = sortedArray.count - 1;
        }
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
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
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - EaseUserCellDelegate
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1)
    {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    PSBuddy *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.userName isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        __weak typeof(self) weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncBlockBuddy:model.buddy.username relationship:eRelationshipFrom withCompletion:^(NSString *username, EMError *error){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideHud];
            if (!error)
            {
                //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            }
            else
            {
                [strongSelf showHint:error.description];
            }
        } onQueue:nil];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - public
- (void)reloadApplyView
{
    NSInteger count = [ApplyViewController shareController].unReadCount;
    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_popView.height)
    {
        [_popView showAnimation];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_popView.height)
    {
        [_popView showAnimation];
    }
}
#pragma mark - EMChatManagerBuddyDelegate
//- (void)didUpdateBlockedList:(NSArray *)blockedList
//{
//    [_contactsSource removeAllObjects];
//    [_contactsSource addObjectsFromArray:[ChatFriendDAO allChatFriends]];
//    [self _sortDataArray:self.contactsSource];
//    [self.tableView reloadData];
//}

//将好友加到黑名单完成后的回调
- (void)didBlockBuddy:(NSString *)username error:(EMError *)pError
{
    // 删除联系人
    EMError *error = nil;
    if (!error)
    {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES append2Chat:YES];
    }
    
//    if ([ChatFriendDAO deletChatFriendWithUsername:username])
//    {
//        [_contactsSource removeAllObjects];
//        [_contactsSource addObjectsFromArray:[ChatFriendDAO allChatFriends]];
//        [self _sortDataArray:self.contactsSource];
//        [self.tableView reloadData];
//    }
    
}

//将好友移出黑名单完成后的回调
//- (void)didUnblockBuddy:(NSString *)username error:(EMError *)pError
//{
//    // 添加好友
//    if (![ChatFriendDAO existChatFriendWithUsername:username])
//    {
//        // 需要添加 请求
//        [self requestNewFriendsWithUsernames:username];
//    }
//}

//- (void)requestNewFriendsWithUsernames:(NSString *)usernames
//{
//    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/InfoList" parameters:@{@"UserNameList":usernames} result:^(NSArray *arr, int status, NSString *msg)
//     {
//         if (status == 1 && arr.count)
//         {
//             [ChatFriendDAO updateChatFriends:arr];
//             
//             [_contactsSource removeAllObjects];
//             [_contactsSource addObjectsFromArray:[ChatFriendDAO allChatFriends]];
//             [self _sortDataArray:self.contactsSource];
//             [self.tableView reloadData];
//         }
//     } convertClassName:@"PSBuddy" key:@"listinfo"];
//}
@end
