//
//  GroupListViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "GroupPersonViewController.h"
#import "GroupListCell.h"
@interface GroupPersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation GroupPersonViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"群成员";
    [self setupTableView];
    [self reloadDataSource];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupListCell" bundle:nil] forCellReuseIdentifier:@"GroupListCell"];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - public

- (void)reloadDataSource
{
    
//    [self.contactsSource removeAllObjects];
    // 要去除黑名单
//    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
//    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
//    for (EMBuddy *buddy in buddyList)
//    {
//        if (![blockList containsObject:buddy.username])
//        {
//            [self.contactsSource addObject:buddy];
//        }
//    }
    
    //    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    //    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    //    if (loginUsername && loginUsername.length > 0)
    //    {
    //        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
    //        [self.contactsSource addObject:loginBuddy];
    //    }
    
    [self _sortDataArray:self.contactsSource];
}

#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [_contactsSource mutableCopy];
    
    //从获取的数据中剔除黑名单中的好友
    //    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    //    for (EMBuddy *buddy in buddyList) {
    //        if (![blockList containsObject:buddy.username]) {
    //            [contactsSource addObject:buddy];
    //        }
    //    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    for (NSString *string in contactsSource)
    {
        NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:string];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:string];
    }
    
    //按首字母分组
//    for (EMBuddy *buddy in contactsSource) {
//        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
//        if (model) {
//            model.avatarImage = [UIImage imageNamed:@"user"];
//            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username];
//            
//            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username]];
//            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
//            
//            NSMutableArray *array = [sortedArray objectAtIndex:section];
//            [array addObject:model];
//        }
//    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult( NSString *obj1, NSString *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1];
            if (IsStrEmpty(firstLetter1))
            {
                firstLetter1 = @" ";
            }
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2];
            if (IsStrEmpty(firstLetter2))
            {
                firstLetter2 = @" ";
            }
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
//    for (int i = 0; i < [sortedArray count]; i++) {
//        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
//            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy.username];
//            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
//            
//            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy.username];
//            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
//            
//            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
//        }];
//        
//        
//        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
//    }
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListCell"];
    
    // Configure the cell...
    
    NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
    NSString *model = [userSection objectAtIndex:indexPath.row];
//    cell.indexPath = indexPath;
//    cell.delegate = self;
    cell.nameLabel.text = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BlackF6F6F6;
    //    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.textColor = Black575757;
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if (section == 0) {
//        if (row == 0) {
//            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
//        }
//        else if (row == 1)
//        {
//            if (_groupController == nil)
//            {
//                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//            }
//            else
//            {
//                [_groupController reloadDataSource];
//            }
//            [self.navigationController pushViewController:_groupController animated:YES];
//        }
//        else if (row == 2)
//        {
//#warning TODO - 黑名单列表
//            BlackListViewController *blakc = [[BlackListViewController alloc]init];
//            [self.navigationController pushViewController:blakc animated:YES];
//        }
//        //        else if (row == 3) {
//        //            RobotListViewController *robot = [[RobotListViewController alloc] init];
//        //            [self.navigationController pushViewController:robot animated:YES];
//        //        }
//    }
//    else
//    {
//        
//        FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//        //        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
//        //        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        //        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//        //        if (loginUsername && loginUsername.length > 0) {
//        //            if ([loginUsername isEqualToString:model.buddy.username]) {
//        //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        //                [alertView show];
//        //
//        //                return;
//        //            }
//        //        }
//        //        NSLog(@"%@",model.buddy.username);
//        //        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy.username conversationType:eConversationTypeChat];
//        //        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy.username;
//        //        [self.navigationController pushViewController:chatController animated:YES];
//    }
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    if (indexPath.section == 0) {
//        return NO;
//    }
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
//        if ([model.buddy.username isEqualToString:loginUsername]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//            [alertView show];
//            
//            return;
//        }
//        
//        EMError *error = nil;
//        [[EaseMob sharedInstance].chatManager removeBuddy:model.buddy.username removeFromRemote:YES error:&error];
//        if (!error) {
//            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.buddy.username deleteMessages:YES append2Chat:YES];
//            
//            [tableView beginUpdates];
//            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
//            [self.contactsSource removeObject:model.buddy];
//            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView  endUpdates];
//        }
//        else{
//            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.description]];
//            [tableView reloadData];
//        }
//    }
//}

- (NSMutableArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
