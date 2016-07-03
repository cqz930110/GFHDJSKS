//
//  ChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ChatViewController.h"

#import "CustomMessageCell.h"

#import "ContactListSelectViewController.h"
#import "PSBarButtonItem.h"
#import "ChatFriendDeatailViewController.h"
#import "PSChatGroupDetailViewController.h"
#import "PSGroup.h"
#import "User.h"
#import "PSBuddy.h"
#import "FriendDetailViewController.h"
#import "PSChat.h"
#import "ChatBuddyDAO.h"
#import "ReflectUtil.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FriendSettingViewController.h"

@interface ChatViewController ()<UIAlertViewDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic,strong) NSMutableDictionary*chats;

@property (nonatomic,assign) NSInteger friendStatus;
@property (nonatomic,strong) NSDictionary *userDic;
@end

@implementation ChatViewController
- (NSMutableDictionary *)chats
{
    if (!_chats)
    {
        _chats = [NSMutableDictionary dictionary];
    }
    return _chats;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat-send-bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat－receiver-bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"]]];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]]];
//    [[EaseMessageCell appearance] setMessageTextColor:[UIColor blackColor]];
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
//    [[EaseBaseMessageCell appearance] setMessageNameColor:[UIColor whiteColor]];
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:[EaseEmoji allEmoji]];
    [self.faceView setEmotionManagers:@[manager]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - setup subviews
- (void)_setupBarButtonItem
{
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    SEL action;
    NSString *imageName;
//#warning TODO - 换头像
    //单聊
    if (self.conversation.conversationType == eConversationTypeChat)
    {
        action = @selector(gotoPersonChatDetail);
        imageName = @"circel_more";
        [self requestFriendDetailWithUserId:self.conversation.chatter];
    }
    else
    {//群聊
        action = @selector(gotoGroupChatDetail);
        imageName = @"circel_more";
       
    }
    
    PSBarButtonItem *item = [PSBarButtonItem itemWithImageName:imageName highLightImageName:nil selectedImageName:nil target:self action:action];
    self.navigationItem.rightBarButtonItem = item;
}

- (NSDictionary *)userDic
{
    if (!_userDic) {
        _userDic = [NSDictionary dictionary];
    }
    return _userDic;
}

//    暂时加上
- (void)requestFriendDetailWithUserId:(NSString *)friendUserName
{
    [self.httpUtil requestDic4MethodName:@"Friend/View" parameters:@{@"UserName":friendUserName} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1) {
            _friendStatus = [[dic objectForKey:@"IsFriend"] integerValue];
            self.userDic = [dic objectForKey:@"User"];
        }else{
            NSLog(@"-------");
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation removeAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]])
    {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)model
{
    if (self.conversation.conversationType == eConversationTypeChat)
    {
        if (model.isSender)
        {
            User *userInfo = [User shareUser];
            model.avatarURLPath = userInfo.avatar;
            model.nickname = userInfo.nickName;
        }
        else
        {
            model.avatarURLPath = self.model.avatarURLPath;
            model.nickname = self.model.title;
        }
    }
    else
    {
        PSChat *chat = [self.chats objectForKey:model.message.groupSenderName];
        if (!chat)
        {
            // 从数据库获取
            chat = [ChatBuddyDAO chatBuddyWithUserame:model.message.groupSenderName];
            if (chat)
            {
                [self.chats setObject:chat forKey:model.message.groupSenderName];
            }
        }
        
        if (!chat)
        {
            // 请求
            [self requestFriendDetailWithUsername:model.message.groupSenderName];
        }
        else
        {
            model.avatarURLPath = chat.avatar;
            model.nickname = chat.showName;
        }
    }
    
    if (model.bodyType == eMessageBodyType_Text) {
        NSString *CellIdentifier = [CustomMessageCell cellIdentifierWithModel:model];
        //发送cell
        CustomMessageCell *sendCell = (CustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (sendCell == nil) {
            sendCell = [[CustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        sendCell.model = model;
        return sendCell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.bodyType == eMessageBodyType_Text)
    {
        return [CustomMessageCell cellHeightWithModel:messageModel];
    }
    return 0.f;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    return flag;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
    if (self.conversation.conversationType == eConversationTypeChat)
    {
        vc.username = messageModel.message.from;
    }
    else
    {
        vc.username = messageModel.message.groupSenderName;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
          didSelectRecordView:(UIView *)recordView
                 withEvenType:(EaseRecordViewType)type
{
    switch (type) {
        case EaseRecordViewTypeTouchDown:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView  recordButtonTouchDown];
            }
        }
            break;
        case EaseRecordViewTypeTouchUpInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeTouchUpOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeDragInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragInside];
            }
        }
            break;
        case EaseRecordViewTypeDragOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragOutside];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"user"];
    model.failImageName = @"user";

    NSString *userName;
    if(self.conversation.conversationType == eConversationTypeChat)
    {
        userName = message.from;
    }
    else
    {
        userName = message.groupSenderName;
    }
    
    
    PSChat *chat = [self.chats objectForKey:userName];
    if (!chat)
    {
        // 从数据库获取
        chat = [ChatBuddyDAO chatBuddyWithUserame:message.from];
        if (chat)
        {
            [self.chats setObject:chat forKey:message.from];
        }
    }
    
    if (!chat)
    {
        // 请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestFriendDetailWithUsername:message.from];
        });
    }
    else
    {
        model.avatarURLPath = chat.avatar;
    }
    return model;
}

- (void)requestFriendDetailWithUsername:(NSString *)username
{
    [self.httpUtil requestDic4MethodName:@"Friend/View" parameters:@{@"UserName":username} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1)
         {
             NSDictionary *userDic = [dic valueForKey:@"User"];
             PSChat *chat = [ReflectUtil reflectDataWithClassName:@"PSChat" otherObject:userDic];
             
             [self.chats setObject:chat forKey:chat.value];
             [ChatBuddyDAO updateChatBuddy:chat];
#warning TODO - 是否刷新
         }
         else
         {
             [MBProgressHUD dismissHUDForView:self.view withError:msg];
         }
     }];
}

#pragma mark - EaseMob

#pragma mark - EMChatManagerLoginDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action
- (void)gotoPersonChatDetail
{
//    ChatFriendDeatailViewController *vc = [[ChatFriendDeatailViewController alloc]init];
//    vc.username = self.conversation.chatter;
//    vc.chatFriendDetailType = ChatFriendDetailTypeBuddy;
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (_userDic) {
        FriendSettingViewController *vc = [[FriendSettingViewController alloc]init];
        vc.friendId = [NSString stringWithFormat:@"%ld",[[_userDic valueForKey:@"Id"] integerValue]];
        vc.username = self.conversation.chatter;
        vc.friendYesOrNo = _friendStatus;
        vc.notes = [_userDic valueForKey:@"Notes"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showMessag:@"阿木请求不到～～" toView:self.view];
    }
    
}

- (void)gotoGroupChatDetail
{
    [self.view endEditing:YES];
    PSChatGroupDetailViewController *vc =[[PSChatGroupDetailViewController alloc]init];
    vc.groupId = self.conversation.chatter;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backAction
{
    [self.view endEditing:YES];
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.chatter];
        if (self.conversation.conversationType != eConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation removeAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessage:model.message];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(MessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"删除", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == eMessageBodyType_Image){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

@end
