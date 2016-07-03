//
//  NewFriendDeatailViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ChatFriendDeatailViewController.h"
#import "NewAddFriendCollectionViewCell.h"
#import "InvitationManager.h"
#import "ApplyViewController.h"
#import "ComplaintViewController.h"
#import "FriendDetailViewController.h"
#import "ReflectUtil.h"
#import "PSBuddy.h"
#import "ChatBuddyDAO.h"
#import "PSChat.h"
#import "FriendSettingViewController.h"
#import "ChatViewController.h"
#import "SendCMDMessageUtil.h"

@interface ChatFriendDeatailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *projectCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *commonFriendLabel;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UILabel *notProjectLabel;

@property (assign, nonatomic) long chatFriendId;

@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation ChatFriendDeatailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    _headerImageView.layer.cornerRadius = _headerImageView.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    [self backBarItem];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    [self.projectCollectionView registerNib:[UINib nibWithNibName:@"NewAddFriendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewAddFriendCollectionViewCell"];
}

- (void)requestFriendDetail
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Friend/View" parameters:@{@"UserName":_username} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            NSDictionary *userDic = [dic valueForKey:@"User"];
            PSBuddy *buddy = [ReflectUtil reflectDataWithClassName:@"PSBuddy" otherObject:userDic];
            _chatFriendId = buddy.Id;
            _nameLabel.text = buddy.reviewName;
            _username = buddy.userName;
            
            NSString *imageUrl = [userDic valueForKey:@"Avatar"];
            if (imageUrl)
            {
                [NetWorkingUtil setImage:_headerImageView url:imageUrl defaultIconName:@"home_默认"];
            }
            _contentLabel.text = buddy.signature;
            _locationLabel.text = buddy.districtName;
           
            NSArray *imageArrs = [dic valueForKey:@"CrowdFundImages"];
            _images = [NSMutableArray arrayWithCapacity:imageArrs.count];
            for (NSDictionary *imagesDic in imageArrs)
            {
                NSString *imagesStr = [imagesDic valueForKey:@"Images"];
                NSArray *imageUrls = [imagesStr componentsSeparatedByString:@","];
                [_images addObjectsFromArray:imageUrls];
            }
            _notProjectLabel.hidden = _images.count;
            [_projectCollectionView reloadData];
            
            // 更新数据库
            PSChat *chat = [ReflectUtil reflectDataWithClassName:@"PSChat" otherObject:userDic];
            chat.showName = buddy.reviewName;
            [ChatBuddyDAO updateChatBuddy:chat];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

#pragma mark - Setter
- (void)setUsername:(NSString *)username
{
    _username = username;
     [self requestFriendDetail];
}

- (void)setChatFriendDetailType:(ChatFriendDetailType)chatFriendDetailType
{
    _chatFriendDetailType = chatFriendDetailType;
    if (_chatFriendDetailType == ChatFriendDetailTypeUnBuddy)
    {
        [_redButton setTitle:@"通过验证" forState:UIControlStateNormal];
        [_greenButton  setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    else
    {
        [_redButton setTitle:@"举报" forState:UIControlStateNormal];
        [_greenButton  setTitle:@"删除好友" forState:UIControlStateNormal];
        
        [self setupBarButtomItemWithImageName:@"circel_more" highLightImageName:nil selectedImageName:nil target:self action:@selector(friendSetting) leftOrRight:NO];
    }
}

#pragma mark - Action
- (void)friendSetting
{
    FriendSettingViewController *vc = [[FriendSettingViewController alloc]init];
    vc.friendId =  [NSString stringWithFormat:@"%zd",_chatFriendId];
    vc.username = _username;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)gotoProject:(UIButton *)sender
{
    //如果没有项目不让跳转
    if (_images.count)
    {
        FriendDetailViewController *vc = [[FriendDetailViewController alloc] init];
        vc.username = _username;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)greenAction:(UIButton *)sender
{
    if (_chatFriendDetailType)
    {
        // 通过验证
        [self requestFirendApplyWithType:@"1"];
    }
    else
    {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        
        if ([_username isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        // 删除好友
        [self.httpUtil requestDic4MethodName:@"Friend/Delete" parameters:@{@"UserName":_username} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             if (status == 1 ||  status == 2)
             {
                 // 删除联系人
                 EMError *error = nil;
                 [[EaseMob sharedInstance].chatManager removeBuddy:_username removeFromRemote:YES error:&error];
                 if (!error)
                 {
                     [[EaseMob sharedInstance].chatManager removeConversationByChatter:_username deleteMessages:YES append2Chat:YES];
                 }
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }
}

- (IBAction)redAction:(UIButton *)sender
{
    if (_chatFriendDetailType)
    {
        //拒绝
        [self requestFirendApplyWithType:@"2"];
    }
    else
    {
        // 举报
        ComplaintViewController *vc = [[ComplaintViewController alloc]init];
        vc.username = _username;
        vc.complaintType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Request
- (void)requestFirendApplyWithType:(NSString*)applyTypeStr
{
    if ([applyTypeStr isEqualToString:@"1"])
    {
        [self agressEaseMobRequest];
    }
    else
    {
        [self unAgressEaseMobRequest];
    }
    // 通过验证
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"FriendApply/Reply" parameters:@{@"UserName":_username,@"Result":applyTypeStr} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             [MBProgressHUD dismissHUDForView:self.view withSuccess:@"操作成功"];
             
              NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
             if ([applyTypeStr isEqualToString:@"1"])
             {
                 // 通过验证
                 _entity.applyState = @(ApplyStateAccept);
                 [InvitationManager addInvitation:_entity loginUser:loginUsername];
                 //创建回话聊天
                 [self gotoChatApplyEntity:_entity];
                 
//                 // 添加好友
//                 if (![ChatFriendDAO existChatFriendWithUsername:_entity.applicantUsername])
//                 {
//                     // 需要添加 请求
//                     [self requestNewFriendsWithUsernames:_entity.applicantUsername];
//                 }
             }
             else
             {
                 //拒绝
                 _entity.applyState = @(ApplyStateReject);
                 [InvitationManager addInvitation:_entity loginUser:loginUsername];
                 [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
             }
             
             [ApplyViewController shareController].unReadCount -= 1;
         }
         else
         {
             [MBProgressHUD dismissHUDForView:self.view withError:msg];
         }
     }];
}

//- (void)requestNewFriendsWithUsernames:(NSString *)usernames
//{
//    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/InfoList" parameters:@{@"UserNameList":usernames} result:^(NSArray *arr, int status, NSString *msg)
//     {
//         if (status == 1 && arr.count)
//         {
//             [ChatFriendDAO updateChatFriends:arr];
//         }
//     } convertClassName:@"PSBuddy" key:@"listinfo"];
//}

- (void)gotoChatApplyEntity:(ApplyEntity *)applyEntity
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:applyEntity.applicantUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:applyEntity.applicantUsername conversationType:eConversationTypeChat];
    [SendCMDMessageUtil sendChatApplyMessageReceiveUsername:applyEntity.applicantUsername];
    chatController.title = applyEntity.applicantNick;
    chatController.isProjectChat = NO;
    UINavigationController *navi = self.navigationController;
    [navi popToRootViewControllerAnimated:NO];
    [navi pushViewController:chatController animated:YES];
}

#pragma mark - EaseMob
- (BOOL)agressEaseMobRequest
{
    ApplyStyle applyStyle = [_entity.style intValue];
    EMError *error;
    
    if (applyStyle == ApplyStyleGroupInvitation) {
        [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:_entity.groupId groupname:_entity.groupSubject applicant:_entity.applicantUsername error:&error];
    }
    else if (applyStyle == ApplyStyleJoinGroup)
    {
        [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:_entity.groupId groupname:_entity.groupSubject applicant:_entity.applicantUsername error:&error];
    }
    else if(applyStyle == ApplyStyleFriend)
    {
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:_entity.applicantUsername error:&error];
    }
    
    if (!error) {
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        _entity.applyState = @(ApplyStateAccept);
        [InvitationManager addInvitation:_entity loginUser:loginUsername];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)unAgressEaseMobRequest
{
    ApplyStyle applyStyle = [_entity.style intValue];
    EMError *error;
    
    if (applyStyle == ApplyStyleGroupInvitation) {
        [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:_entity.groupId groupname:_entity.groupSubject toApplicant:_entity.applicantUsername reason:@"不加入"];
    }
    else if (applyStyle == ApplyStyleJoinGroup)
    {
        [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:_entity.groupId groupname:_entity.groupSubject toApplicant:_entity.applicantUsername reason:@"不加入"];
    }
    else if(applyStyle == ApplyStyleFriend){
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:_entity.applicantUsername reason:@"拒绝" error:&error];
    }

    if (!error)
    {
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        _entity.applyState = @(ApplyStateReject);
        [InvitationManager addInvitation:_entity loginUser:loginUsername];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (_images.count)
    {
        number = _images.count > 4?4:_images.count;
    }
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewAddFriendCollectionViewCell *cell = [_projectCollectionView dequeueReusableCellWithReuseIdentifier:@"NewAddFriendCollectionViewCell" forIndexPath:indexPath];
    [cell setimageUrl:_images[indexPath.row]];
    return cell;
}

@end
