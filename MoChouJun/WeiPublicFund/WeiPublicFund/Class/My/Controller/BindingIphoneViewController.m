//
//  BindingIphoneViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/13.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BindingIphoneViewController.h"
#import "BindingNewIphoneViewController.h"

@interface BindingIphoneViewController ()
{
    int timerSecond;
}
@property (strong, nonatomic) NSTimer *deadTimer;
@end

@implementation BindingIphoneViewController

- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
}

-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _checkNumBtn.backgroundColor = [UIColor colorWithHexString:@"#F3A742"];
        [_checkNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_checkNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkNumBtn.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_checkNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}

-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 60;
        _checkNumBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_checkNumBtn setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_checkNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _checkNumBtn.userInteractionEnabled = NO;
        self.deadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashBtnStatus) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer{
    [self.deadTimer invalidate];
    self.deadTimer = nil;
}

-(void)dealloc{
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机";
    [self backBarItem];
    _checkNumBtn.layer.cornerRadius = 2.0f;
    _checkNumBtn.backgroundColor = [UIColor colorWithHexString:@"#F3A742"];
    [_checkNumBtn addTarget:self action:@selector(checkNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBindingIphoneBtn.layer.cornerRadius = 5.0f;
    _nextBindingIphoneBtn.userInteractionEnabled = NO;
    [_nextBindingIphoneBtn addTarget:self action:@selector(nextBindingIphoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_checkNumTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
//    [_checkNumTextField becomeFirstResponder];
    _iphoneTextField.text = _mobile;
    _iphoneTextField.userInteractionEnabled = NO;
    
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_checkNumTextField.text)) {
        _nextBindingIphoneBtn.userInteractionEnabled = NO;
        _nextBindingIphoneBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }else if (!IsStrEmpty(_iphoneTextField.text) && !IsStrEmpty(_checkNumTextField.text)) {
        _nextBindingIphoneBtn.userInteractionEnabled = YES;
        _nextBindingIphoneBtn.backgroundColor = [UIColor colorWithHexString:@"#F3A742"];
    }
}

- (void)checkNumBtnClick:(UIButton *)sender
{
    [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_iphoneTextField.text,@"TypeId":@(3)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [self startTimer];
            _checkNumBtn.userInteractionEnabled = NO;
            [MBProgressHUD showSuccess:msg toView:self.view];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    }];
}

- (void)nextBindingIphoneBtnClick:(UIButton *)sender
{
    [_checkNumTextField resignFirstResponder];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Personal/ValidteMobile" parameters:@{@"Mobile":_iphoneTextField.text,@"TypeId":@"3",@"Code":_checkNumTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [self.navigationController pushViewController:[[BindingNewIphoneViewController alloc]init] animated:YES];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}
@end
