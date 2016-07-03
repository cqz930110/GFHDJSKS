//
//  RegisterViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterOneViewController.h"
#import "ValidateUtil.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendCoderBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (strong, nonatomic) NSMutableDictionary *registerDic;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sendCoderBtn.layer.cornerRadius = 5.0f;
    self.title = @"手机注册";
    [self backBarItem];
}

- (IBAction)registerOneClick:(id)sender
{
//    RegisterOneViewController *registerOneVC = [[RegisterOneViewController alloc]init];
//    [self.navigationController pushViewController:registerOneVC animated:YES];
    [_phoneNumTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    if ([ValidateUtil isMobileNumber:_phoneNumTextField.text])
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_phoneNumTextField.text,@"TypeId":@(1)} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             button.userInteractionEnabled = YES;
             if (status ==1 || status == 2)
             {
                 // 发送验证码
                 [MBProgressHUD dismissHUDForView:self.view];
                 RegisterOneViewController *registerOneVC = [[RegisterOneViewController alloc]init];
                 _registerDic = [NSMutableDictionary dictionary];
                 [_registerDic setValue:_phoneNumTextField.text forKey:@"Mobile"];
                 [_registerDic setValue:@"1" forKey:@"TypeId"];
                 registerOneVC.registerDic = _registerDic;
                 registerOneVC.valicateCode = (NSString *)dic;
                 registerOneVC.mobile = _phoneNumTextField.text;
                 [self.navigationController pushViewController:registerOneVC animated:YES];
                 
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
