//
//  ForgetAndRegisterViewController.m
//  NT
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 Pem. All rights reserved.
//

#import "ForgetAndRegisterViewController.h"
#import "ResetPsdOneViewController.h"
#import "ValidateUtil.h"
#import "User.h"

@interface ForgetAndRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendCoderBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (strong, nonatomic) NSMutableDictionary *passwordDic;
@end

@implementation ForgetAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sendCoderBtn.layer.cornerRadius = 5.0f;
    self.title = @"重置密码";
    [self backBarItem];
    User *user = [User userFromFile];
    _phoneNumTextField.text = user.mobile;
}

- (IBAction)nextResetPsd:(id)sender
{
    [_phoneNumTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    if ([ValidateUtil isMobileNumber:_phoneNumTextField.text])
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_phoneNumTextField.text,@"TypeId":@(2)} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             button.userInteractionEnabled = YES;
             if (status ==1 || status == 2)
             {
                 // 发送验证码
                [MBProgressHUD dismissHUDForView:self.view];
                 ResetPsdOneViewController *reSetPsdVC = [[ResetPsdOneViewController alloc]init];
                 _passwordDic = [NSMutableDictionary dictionary];
                 [_passwordDic setValue:_phoneNumTextField.text forKey:@"Mobile"];
                 [_passwordDic setValue:@"2" forKey:@"TypeId"];
                 reSetPsdVC.passwordDic = _passwordDic;
                 reSetPsdVC.statuCode = (NSString *)dic;
                 reSetPsdVC.mobile = _phoneNumTextField.text;
                 [self.navigationController pushViewController:reSetPsdVC animated:YES];
                 
             }
             else
             {
                [MBProgressHUD dismissHUDForView:self.view withError:msg];
             }
         }];
        
    }
    else
    {
        button.userInteractionEnabled = YES;
        [MBProgressHUD showMessag:@"输入的手机号码不正确" toView:self.view];
    }

//    if ([ValidateUtil isMobileNumber:_phoneNumTextField.text])
//    {
//        ResetPsdOneViewController *reSetPsdVC = [[ResetPsdOneViewController alloc]init];
//        _passwordDic = [NSMutableDictionary dictionary];
//        [_passwordDic setValue:_phoneNumTextField.text forKey:@"Mobile"];
//        [_passwordDic setValue:@"2" forKey:@"TypeId"];
//        reSetPsdVC.passwordDic = _passwordDic;
//        reSetPsdVC.mobile = _phoneNumTextField.text;
//        [self.navigationController pushViewController:reSetPsdVC animated:YES];
//    }
//    else
//    {
//        [MBProgressHUD showError:@"输入的手机号码不正确" toView:self.view];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
