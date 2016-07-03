//
//  ResetPsdTwoViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "ResetPsdTwoViewController.h"
#import "ValidateUtil.h"

@interface ResetPsdTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *setPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *commitPsdTextField;
@end

@implementation ResetPsdTwoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"重置密码";
    [self backBarItem];
    _commitBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)commitResetClick:(id)sender
{
    [_setPsdTextField resignFirstResponder];
    [_commitBtn resignFirstResponder];
    if (IsStrEmpty(_setPsdTextField.text) || IsStrEmpty(_commitPsdTextField.text))
    {
        [MBProgressHUD showMessag:@"输入密码为空！" toView:self.view];
        return;
    }
    
    if (![_setPsdTextField.text isEqual:_commitPsdTextField.text]) {
        [MBProgressHUD showMessag:@"两次密码输入不一致" toView:self.view];
        return;
    }
    
    if (![ValidateUtil isValidateUserNameOrPassword:_setPsdTextField.text])
    {
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"密码应为6-16位字母+数字";
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.5秒之后再消失
        [hud hide:YES afterDelay:1];
        return;
    }
    
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    [_passwordDic setValue:_setPsdTextField.text forKey:@"PassWord"];
    [self.httpUtil requestDic4MethodName:@"Auth/RestPass" parameters:_passwordDic result:^(NSDictionary *dic, int status, NSString *msg) {
        button.userInteractionEnabled = YES;
        if (status == 1 || status == 2) {
            [MBProgressHUD showSuccess:msg toView:self.view];
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5f];
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
