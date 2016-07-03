//
//  FriendSetingMarkNameViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/21.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FriendSetingMarkNameViewController.h"
#import "ChatBuddyDAO.h"
#import "PSChat.h"
#import "PSBuddy.h"

@interface FriendSetingMarkNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *markNameTextField;

@end

@implementation FriendSetingMarkNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置备注";
    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(changeMarkName) leftOrRight:NO];
    _markNameTextField.text = _notes;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_markNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_markNameTextField resignFirstResponder];
}

- (void)changeMarkName
{
    [_markNameTextField resignFirstResponder];
    if (IsStrEmpty(_markNameTextField.text))
    {
        [MBProgressHUD showMessag:@"给好友取一个响亮的名字呗" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Friend/SetNote" parameters:@{@"UserName":_username,@"Notes":_markNameTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD showSuccess:msg toView:nil];
            [MBProgressHUD dismissHUDForView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegate respondsToSelector:@selector(showMarkName:)]) {
                [self.delegate showMarkName:_markNameTextField.text];
            }
            PSChat *chat = [ChatBuddyDAO chatBuddyWithUserame:_username];
            [ChatBuddyDAO updateChatBuddy:chat];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

@end
