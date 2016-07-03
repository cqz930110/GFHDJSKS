//
//  ModifyLoginPsdViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/13.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ModifyLoginPsdViewController.h"
#import "LoginViewController.h"
#import "ValidateUtil.h"
#import "BaseNavigationController.h"
@interface ModifyLoginPsdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *settingPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitPsdBtn;

@end

@implementation ModifyLoginPsdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    [self backBarItem];
    
    _commitPsdBtn.layer.cornerRadius = 5.0f;
    [_commitPsdBtn addTarget:self action:@selector(commitPsdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitPsdBtnClick:(UIButton *)sender
{
//    
    if (IsStrEmpty(_settingPasswordTextField.text) || IsStrEmpty(_oldPasswordTextField.text) || IsStrEmpty(_againPasswordTextField.text)) {
        [MBProgressHUD showMessag:@"输入密码不能为空！" toView:self.view];
        return;
    }
    
    if (![_settingPasswordTextField.text isEqualToString:_againPasswordTextField.text]){
        [MBProgressHUD showMessag:@"两次密码输入不一致" toView:self.view];
        return;
    }
    
    if (![ValidateUtil isValidateUserNameOrPassword:_settingPasswordTextField.text])
    {
        [MBProgressHUD showMessag:@"密码应为6-16位字母+数字" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Personal/ChangePwd" parameters:@{@"OldPwd":_oldPasswordTextField.text,@"NewPwd":_againPasswordTextField.text,@"ComfirmPwd":_settingPasswordTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 2 || status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"修改成功"];
            LoginViewController * login = [[LoginViewController alloc] init];
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:navi animated:YES completion:nil];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)delayMethod{
    
}

@end
