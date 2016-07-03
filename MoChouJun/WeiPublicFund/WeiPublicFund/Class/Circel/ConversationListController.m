//
//  ConversationListController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ConversationListController.h"

#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "PSBarButtonItem.h"
#import "AddFriendViewController.h"
#import "AddPopoverView.h"
#import "ContactSelectionViewController.h"
#import "ContactListViewController.h"
#import "PSBuddy.h"
#import "SendCMDMessageUtil.h"
#import "ChatBuddyDAO.h"
#import "PSChat.h"
#import "User.h"

@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        return [ChatBuddyDAO chatBuddyWithUserame:self.chatter].showName;
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}

@end

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate,AddPopverViewDelegate,EMChooseViewDelegate>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) EMSearchBar           *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) PSBarButtonItem *addItem;
@property (strong, nonatomic) AddPopoverView *popView;
@end

@implementation ConversationListController//ContactSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTableView];
    
    [self networkStateView];
    
    [self searchController];

    [self removeEmptyConversationsFromDB];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.title = @"圈子";;
    self.tabBarController.navigationItem.leftBarButtonItem = self.addItem;
    [self setBarButtonItems];
}

- (void)setBarButtonItems
{
    UIBarButtonItem *myButton1 = [[UIBarButtonItem alloc]
                                  initWithTitle:@"添加 "
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(addAction)];
    myButton1.width = 40;
    [myButton1 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    
    UIBarButtonItem *myButton2 = [[UIBarButtonItem alloc]
                  initWithTitle:@""
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:nil];
    myButton2.width = 60;
    [myButton2 setTintColor:[UIColor clearColor]];
    myButton2.enabled = NO;
    self.tabBarController.navigationItem.rightBarButtonItems = @[myButton1,myButton2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_popView.height)
    {
        [_popView showAnimation];
    }
    [super viewWillDisappear:animated];
}

- (PSBarButtonItem *)addItem{
    if (!_addItem)
    {
        _addItem = [PSBarButtonItem itemWithTitle:@" 通讯录" barStyle:PSNavItemStyleDone target:self action:@selector(contactList)];
    }
    
    return _addItem;
}

- (void)setupTableView
{
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma Override
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.popView showAnimation];
//}

#pragma mark -Action
- (void)addAction
{
    [_searchController setActive:NO animated:YES];
//    [_searchCrowdFundArr removeAllObjects];
    [_searchBar resignFirstResponder];
    [self.popView showAnimation];
}

- (void)contactList
{
    [_searchController setActive:NO animated:YES];
    //    [_searchCrowdFundArr removeAllObjects];
    [_searchBar resignFirstResponder];
    if (_popView.height)
    {
        [_popView showAnimation];
    }
    ContactListViewController *contactListVC = [ContactListViewController new];
    [self.navigationController pushViewController:contactListVC animated:YES];
}

#pragma mark - getter


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


- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"网管去哪了，你又不是城管，来管下网络好么";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索好友/群聊";
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
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak ConversationListController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
            EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.model = model;
            
            cell.detailLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
            cell.detailLabel.attributedText = [EaseEmotionEscape attStringFromTextForChatting:cell.detailLabel.text];
            cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [EaseConversationCell cellHeightWithModel:nil];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            EMConversation *conversation = model.conversation;
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
                chatController.title = [conversation showName];
            
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_popView.height)
    {
        [_popView showAnimation];
    }
}

#pragma mark - EaseConversationListViewControllerDelegate
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (self.popView.height >0)
    {
        [self.popView showAnimation];
        return;
    }
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
            chatController.title = conversationModel.title;
            chatController.model = conversationModel;
            [self.navigationController pushViewController:chatController animated:YES];
            
        }
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.conversationType == eConversationTypeChat) {
        
       
        PSChat *chat = [ChatBuddyDAO chatBuddyWithUserame:conversation.chatter];
        if (chat) {
            model.title = chat.showName;
            model.avatarURLPath = chat.avatar;
        }
    }
    else if (model.conversation.conversationType == eConversationTypeGroupChat)
    {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    model.title = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    model.avatarImage = [UIImage imageNamed:imageName];
                    
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        else
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
//                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    NSString *groupSubject = [ext objectForKey:@"groupSubject"];
                    NSString *conversationSubject = [conversation.ext objectForKey:@"groupSubject"];
                    if (groupSubject && conversationSubject && ![groupSubject isEqualToString:conversationSubject]) {
                        conversation.ext = ext;
                    }
                    break;
                }
            }
            model.title = [conversation.ext objectForKey:@"groupSubject"];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
            model.avatarImage = [UIImage imageNamed:imageName];
        }
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                latestMessageTitle = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                
                // 判断是否是好友申请message
                NSString *text = ((EMTextMessageBody *)messageBody).text;
                NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
                if (conversationModel.conversation.conversationType == eConversationTypeChat && [lastMessage.from isEqualToString:loginUsername] && [text rangeOfString:@"我通过了你的好友验证请求"].location != NSNotFound)
                {
                    PSChat *chat = [ChatBuddyDAO chatBuddyWithUserame:lastMessage.to];
                    
                    latestMessageTitle = [NSString stringWithFormat:@"你已经添加了\"%@\",现在可以开始聊天了",chat.showName];
                    break;
                }
                
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                latestMessageTitle = @"[音频]";
            } break;
            case eMessageBodyType_Location: {
                latestMessageTitle =@"[位置]";
            } break;
            case eMessageBodyType_Video: {
                latestMessageTitle = @"[视频]";
            } break;
            case eMessageBodyType_File: {
                latestMessageTitle = @"文件";
            } break;
            default: {
            } break;
        }
    }
    
    return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:(NSString *)searchText collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
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

#pragma mark - public

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect
{
    if (!isConnect)
    {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(@"开始接收离线消息");
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(@"离线消息接收成功");
}

- (void)reloadGroupView
{    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}
@end
