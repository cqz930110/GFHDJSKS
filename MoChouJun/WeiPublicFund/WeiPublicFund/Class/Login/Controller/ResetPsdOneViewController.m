//
//  ResetPsdOneViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "ResetPsdOneViewController.h"
#import "ResetPsdTwoViewController.h"
#import "HWWeakTimer.h"


@interface ResetPsdOneViewController ()<UITextFieldDelegate>
{
    int timerSecond;
}
@property (strong, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UIButton *checkCoderBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITextField *checkCoderTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@end

@implementation ResetPsdOneViewController
#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        [_checkCoderBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _checkCoderBtn.enabled = YES;
        _checkCoderBtn.backgroundColor = [UIColor colorWithHexString:@"#B37DD4"];
        timerSecond = 60;
        [_checkCoderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self stopTimer];
    }
    else
    {
        
        [_checkCoderBtn setTitle:[NSString stringWithFormat:@"获取中(%dS)",timerSecond] forState:UIControlStateNormal];
    }
}

-(void)startTimer{
    if (!self.deadTimer) {
        [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_mobile,@"TypeId":@(2)} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             
             if (status ==1 || status == 2)
             {
                 _statuCode = (NSString *)dic;
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

-(void)dealloc{
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self backBarItem];
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
    _checkCoderTextField.text = @"";
}

- (IBAction)checkCoderClick:(id)sender
{
    [self startTimer];
    _checkCoderBtn.enabled = NO;
    _checkCoderBtn.backgroundColor = BlackDDDDDD;
    [_checkCoderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)reSetPsdCommit:(id)sender {
    
    [_checkCoderTextField resignFirstResponder];
    [_userTextField resignFirstResponder];
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    // 判断是否为空
    if (IsStrEmpty(_checkCoderTextField.text))
    {
        [MBProgressHUD showMessag:@"验证码不能为空" toView:self.view];
        return;
    }
    
    if (IsStrEmpty(_userTextField.text))
    {
        [MBProgressHUD showMessag:@"用户名不能为空" toView:self.view];
        return;
    }
    
    if (![_checkCoderTextField.text isEqual:_statuCode]) {
        [MBProgressHUD showMessag:@"验证码错误" toView:self.view];
        return;
    }

    // 判断用户名和手机号码是否匹配
    [self.httpUtil requestDic4MethodName:@"/Auth/CheckMobileUserName" parameters:@{@"UserName":_userTextField.text,@"Mobile":[_passwordDic valueForKey:@"Mobile"]} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        button.userInteractionEnabled = YES;
        if (status == 1 || status == 2)
        {
            NSString *statusCode = (NSString *)dic;
            NSInteger status = [statusCode intValue];
            if (status)
            {
                //判断用户名是否存在
                ResetPsdTwoViewController *resetPsdTwoVC = [[ResetPsdTwoViewController alloc] init];
                [_passwordDic setValue:_statuCode forKey:@"MobileCode"];
                resetPsdTwoVC.passwordDic = _passwordDic;
                [self.navigationController pushViewController:resetPsdTwoVC animated:YES];
            }
            else
            {
                [MBProgressHUD showError:msg toView:self.view];
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
    return [regextestmobile evaluateWithObject:_userTextField.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![string isEqualToString:@""])
    {
        if (range.location == 0)
        {
            if (IsStrEmpty(_checkCoderTextField.text) && IsStrEmpty(_userTextField.text))
            {
                _nextBtn.enabled = NO;
            }
            else
            {
                _nextBtn.enabled = YES;
            }
        }
        else
        {
            if (IsStrEmpty(_checkCoderTextField.text) || IsStrEmpty(_userTextField.text))
            {
                _nextBtn.enabled = NO;
            }
            else
            {
                _nextBtn.enabled = YES;
                
            }
        }
    }
    else
    {
        if (range.location == 0)
        {
             _nextBtn.enabled = NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
