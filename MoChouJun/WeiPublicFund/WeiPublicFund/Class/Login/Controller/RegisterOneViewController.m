//
//  RegisterOneViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "RegisterOneViewController.h"
#import "RegisterTwoViewController.h"
#import "HWWeakTimer.h"

@interface RegisterOneViewController ()
{
    int timerSecond;
}
@property (weak, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UIButton *checkCoderBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITextField *checkCoderTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@end

@implementation RegisterOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"用户名";
    timerSecond = 60;
    _checkCoderBtn.layer.cornerRadius = 5.0f;
    _nextBtn.layer.cornerRadius = 5.0f;
    _checkCoderBtn.enabled = NO;
    _checkCoderBtn.backgroundColor = BlackDDDDDD;
    [_checkCoderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.deadTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashBtnStatus) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_checkCoderTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    _checkCoderTextField.text = @"";
}

-(void)dealloc
{
    [self stopTimer];
}

#pragma mark - timer
-(void)startTimer
{
    if (!self.deadTimer)
    {
        [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_mobile,@"TypeId":@(1)} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             
             if (status ==1 || status == 2)
             {
                  _valicateCode = (NSString *)dic;
             }
             else
             {
                 [MBProgressHUD showError:msg toView:self.view];
                 timerSecond = 1;
             }
         }];
        
        
        [_checkCoderBtn setTitle:[NSString stringWithFormat:@"获取中(%dS)",timerSecond] forState:UIControlStateNormal];
        self.deadTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashBtnStatus) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer
{
    [self.deadTimer invalidate];
    self.deadTimer = nil;
}

-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0)
    {
        [self stopTimer];
        [_checkCoderBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _checkCoderBtn.enabled = YES;
        _checkCoderBtn.backgroundColor = [UIColor colorWithHexString:@"#B37DD4"];
        timerSecond = 60;
        [_checkCoderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else
    {
        [_checkCoderBtn setTitle:[NSString stringWithFormat:@"获取中(%dS)",timerSecond] forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (IBAction)checkCoderClick:(id)sender {
    [self startTimer];
    _checkCoderBtn.enabled = NO;
    _checkCoderBtn.backgroundColor = BlackDDDDDD;
    [_checkCoderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)registerTwoClick:(id)sender
{
    [_checkCoderTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    // 判断是否为空
    if (IsStrEmpty(_checkCoderTextField.text))
    {
        [MBProgressHUD showMessag:@"验证码不能为空" toView:self.view];
        return;
    }
    
    if (IsStrEmpty(_userNameTextField.text))
    {
        [MBProgressHUD showMessag:@"用户名不能为空" toView:self.view];
        return;
    }
    
    // 判断 验证码是否正确
//    if (![_checkCoderTextField.text isEqualToString:_valicateCode])
//    {
//        [MBProgressHUD showMessag:@"验证码错误" toView:self.view];
//        return;
//    }
    
    // 判断用户名是否 合法
    if (![self isValidateUsername])
    {
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"用户名由3-15个字母或数字或字母+数字";
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
    
    //判断用户名是否存在
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"Auth/IsExsist" parameters:@{@"UserName":_userNameTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        button.userInteractionEnabled = YES;
        if (status == 1)
        {
            NSInteger value = [[dic valueForKey:@"IsExsist"] integerValue];
            if (value == 0)
            {
                [_registerDic setValue:_checkCoderTextField.text forKey:@"MobileCode"];
                [_registerDic setValue:_userNameTextField.text forKey:@"UserName"];
                [_registerDic setValue:@(1) forKey:@"MobCodeTypeId"];
                RegisterTwoViewController *registerTwoVC = [[RegisterTwoViewController alloc] init];
                registerTwoVC.registerDic = _registerDic;
                [self.navigationController pushViewController:registerTwoVC animated:YES];

            }
            else
            {
                [MBProgressHUD showError:@"用户名已存在" toView:self.view];
            }
            
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (BOOL)isValidateUsername;
{
    NSString *regex = @"^[0-9a-zA-Z]{3,15}$";   //以A开头，e结尾
    //    @"name MATCHES %@",regex
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    [regextestmobile evaluateWithObject:_userNameTextField.text];
    
    //3-15个字母或数字或字母+数字
    return [regextestmobile evaluateWithObject:_userNameTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
