//
//  FriendSettingViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/21.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FriendSettingViewController.h"
#import "FriendSetingMarkNameViewController.h"
#import "ComplaintViewController.h"
#import "User.h"
#import "ApplyViewController.h"
#import "InvitationManager.h"

@interface FriendSettingViewController ()<FriendSetingMarkNameViewControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *blackSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLab;

@end

@implementation FriendSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资料设置";
    [self backBarItem];
    
    if (!_friendYesOrNo) {
        [_deleteBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    
    _remarkNameLab.text = _notes;
}

//    FriendSetingMarkNameViewControllerDelegate
- (void)showMarkName:(NSString *)name
{
    _remarkNameLab.text = name;
}

#pragma mark - Actions
- (IBAction)settingName:(UIButton *)sender
{
    FriendSetingMarkNameViewController *vc = [[FriendSetingMarkNameViewController alloc]init];
    vc.notes = _notes;
    vc.username = _username;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//   举报此人
- (IBAction)reportBtnClick:(id)sender {
    ComplaintViewController *vc = [[ComplaintViewController alloc]init];
    // 改成UserName
    vc.username = _username;
    vc.complaintType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

// 删除好友
- (IBAction)deleteFriend
{
    if (_friendYesOrNo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 2000;
        [alertView show];
        
    }else{
        //   添加好友
        
        //判断是否已发来申请
        NSArray *applyArray = [[ApplyViewController shareController] dataSource];
        if (applyArray && [applyArray count] > 0)
        {
            for (ApplyEntity *entity in applyArray)
            {
                ApplyStyle style = [entity.style intValue];
                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
                if (isGroup)
                {
                    continue;
                }
                
                if ([entity.applicantUsername isEqualToString:_username] && [entity.applyState integerValue] == ApplyStateAcceptApplying) {
                    NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", _username];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
        }
        
        // 发送添加好友的请求
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定添加该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 1000;
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            [MBProgressHUD showStatus:nil toView:self.view];
            [self.httpUtil requestDic4MethodName:@"FriendApply/Apply" parameters:@{@"UserName":_username} result:^(NSDictionary *dic, int status, NSString *msg)
             {
                 if (status == 1 || status == 2)
                 {
                     EMError *error;
                     NSLog(@"%@",_username);
                     [[EaseMob sharedInstance].chatManager addBuddy:_username message:@"添加你为好友" error:&error];
                     if (error)
                     {
                         [MBProgressHUD dismissHUDForView:self.view withError:@"发送申请失败，请重新操作"];
                     }
                     else
                     {
                         [MBProgressHUD dismissHUDForView:self.view withSuccess:@"阿么已为您传送消息了，请坐等回应"];
                         [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
                     }
                 }
                 else
                 {
                     [MBProgressHUD dismissHUDForView:self.view withError:msg];
                 }
                 
             }];
        }
    }else if (alertView.tag == 2000){
        // 删除好友
        if (buttonIndex == 1) {
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
}

#pragma mark - Request
- (void)requestSettingFreindWithSwitch:(UISwitch *)switchView
{
//    [MBProgressHUD showStatus:nil toView:self.view];
//    [self.httpUtil requestDic4MethodName:@"Friend/Edit" parameters:@{@"StatusId":@(_blackSwitch.on),@"UserName":_username,@"INotSeeHimId":@(!_watchFriendSpaceSwitch.on),@"HeNotSeeMeId":@(!_watchMeSpaceSwitch.on)} result:^(NSDictionary *dic, int status, NSString *msg)
//    {
//        if (status == 1 || status == 2)
//        {
//            [MBProgressHUD dismissHUDForView:self.view];
//            
//            if (switchView.tag == 100)
//            {
////                EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:_username];
//                if (_blackSwitch.on)
//                {
//                    [[EaseMob sharedInstance].chatManager asyncBlockBuddy:_username relationship:eRelationshipFrom];
//                }
//                else
//                {
//                    [[EaseMob sharedInstance].chatManager asyncUnblockBuddy:_username];
//                }
//            }
//            
//            [switchView setOn:switchView.on animated:YES];
//        }
//        else
//        {
//            [MBProgressHUD dismissHUDForView:self.view withError:msg];
//        }
//    }];
}

- (void)setUsername:(NSString *)username
{
    _username = username;
//    [self.httpUtil requestDic4MethodName:@"Friend/GetSetting" parameters:@{@"UserName":_username} result:^(NSDictionary *dic, int status, NSString *msg)
//     {
//         NSLog(@"%@",dic);
//         if (status == 1)
//         {
//             /// 备注与标签
//             _notes = [dic valueForKey:@"Notes"];
//             /// 是否不看他的动态，  0不看 1看   CommonStatus
//             NSInteger commonStatus = [[dic valueForKey:@"INotSeeHimId"] integerValue];
//             //         NSString *commonStatusStr = [NSString stringWithFormat:@"%d",commonStatus];
//             BOOL watchFriend = commonStatus == 0?YES:NO;
//             [_watchFriendSpaceSwitch setOn:watchFriend];
//             
//             
//             /// 是否不让他看我的动态，0不看  1看  CommonStatus
//             NSInteger heNotSeeStauts = [[dic valueForKey:@"HeNotSeeMeId"] integerValue];
//             BOOL watchMeSpace = heNotSeeStauts == 0?YES:NO;
//             [_watchMeSpaceSwitch setOn:watchMeSpace];
//             
//             
//             /// 好友状态Id，  0 正常  1黑名单 2已删除
//             NSInteger friendStatus = [[dic valueForKey:@"StatusId"] integerValue];
//             BOOL blackStatus = friendStatus == 0?NO:YES;
//             [_blackSwitch setOn:blackStatus];
//         }
//         else
//         {
//             [MBProgressHUD showError:msg toView:self.view];
//         }
//         
//     }];
}

@end
