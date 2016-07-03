//
//  LoginViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/11/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "LoginViewController.h"
#import "EMError.h"
#import "User.h"
#import "IOSmd5.h"
#import "RegisterViewController.h"
#import "ForgetAndRegisterViewController.h"
#import "ApplyViewController.h"
#import "ShareUtil.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import <Masonry/Masonry.h>
#import "HWWeakTimer.h"
#import "ValidateUtil.h"
//#import "ChatFriendDAO.h"
@interface LoginViewController ()
{
    NSInteger _timerSecond;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *veriCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *veriCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLoginViewCenterXConstraint;

@property (copy, nonatomic) NSString *otherLoginPassword;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *otherLoginButtons;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) NSTimer *deadTimer;
@end

@implementation LoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    _timerSecond = 60;
    User *user = [User shareUser];
    _phoneNumTextField.text = user.mobile;
    [self backBarItem];

    _veriCodeButton.layer.cornerRadius = 5.0f;
    
    // 没有安装三方隐藏 三方登录按钮
    
//    [self setupBarButtomItemWithTitle:@"注册" target:self action:@selector(doRegister:) leftOrRight:NO];
}

//#warning TODO 
//#pragma message haha
//#error

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self hideOtherButtons];
}

- (void)dealloc
{
    [_deadTimer invalidate];
    _deadTimer = nil;
}

- (void)backAction
{
    // 清除数据
    if ([User isLogin])
    {
        [MBProgressHUD showStatus:@"正在退出中..." toView:self.view];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            
            if (error && error.errorCode != EMErrorServerNotLogin)
            {
                [MBProgressHUD dismissHUDForView:self.view withError:error.description];
            }
            else
            {
                [MBProgressHUD dismissHUDForView:self.view];
                // 清理数据
                User *user = [User shareUser];
                [user clearData];
            }
        } onQueue:nil];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Action
- (IBAction)textDidChange
{
    BOOL isCanLogin = (_phoneNumTextField.text.length > 0 && _veriCodeTextField.text.length > 0);
    _loginButton.enabled = isCanLogin;
}

- (IBAction)getVeriCode:(UIButton *)sender
{
    if (![ValidateUtil isMobileNumber:_phoneNumTextField.text])
    {
        [MBProgressHUD showMessag:@"请输入正确的手机号码" toView:nil];
        return ;
    }
    
    // 判断手机号码
    sender.enabled = NO;
    if (!self.deadTimer)
    {
        [_veriCodeButton setTitle:[NSString stringWithFormat:@"获取中(%zd)",60] forState:UIControlStateNormal];
        self.deadTimer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVeriCodeChange:) userInfo:nil repeats:YES];
        // 获取验证码
        [self.httpUtil requestDic4MethodName:@"Auth/SendMobCode" parameters:@{@"Mobile":_phoneNumTextField.text,@"TypeId":@(6)} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             if (status == 1 || status == 2)
             {
                 
             }
             else
             {
                 [self stopTimer];
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }
}

- (void)stopTimer
{
    [_deadTimer invalidate];
    _deadTimer = nil;
    [_veriCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    _veriCodeButton.enabled = YES;
    _timerSecond = 60;
}

- (void)timeVeriCodeChange:(NSTimer *)timer
{
    _timerSecond --;
    if (_timerSecond == 0)
    {
        [self stopTimer];
    }
    else
    {
        [_veriCodeButton setTitle:[NSString stringWithFormat:@"获取中(%zd)",_timerSecond] forState:UIControlStateNormal];
    }
}

- (IBAction)doLogin:(id)sender
{
    [self.view endEditing:YES];
    if (IsStrEmpty(_phoneNumTextField.text))
    {
        [MBProgressHUD showMessag:@"请输入手机号码" toView:nil];
        return ;
    }
    
    if (IsStrEmpty(_veriCodeTextField.text))
    {
        [MBProgressHUD showMessag:@"请输入验证码" toView:nil];
        return ;
    }
    
    if (![ValidateUtil isMobileNumber:_phoneNumTextField.text])
    {
        [MBProgressHUD showMessag:@"请输入正确的手机号码" toView:nil];
        return ;
    }
    
    [self requestLoginWithPhoneNum:_phoneNumTextField.text veriCode:_veriCodeTextField.text];
}

- (IBAction)findBackPassword:(UIButton *)sender
{
    ForgetAndRegisterViewController *vc = [[ForgetAndRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//   tag 0 新浪微博  xinlang  tag 1 QQ qq   tag 2 微信 weixin
- (void)hideOtherButtons
{
   BOOL isHideWeiXin = [ShareUtil hideButtonWithThreeType:UMShareToWechatSession];
    UIButton *weixinButton = _otherLoginButtons[2];
    if (isHideWeiXin)
    {
        _otherLoginViewCenterXConstraint.constant = (weixinButton.width + 55) * 0.5;
    }
    else
    {
        _otherLoginViewCenterXConstraint.constant = 0;
        weixinButton.hidden = NO;
        _weixinLabel.hidden = NO;
    }
}

- (IBAction)otherLogin:(UIButton *)sender
{
    NSString *snsName;
    switch (sender.tag)
    {
        case 0:
            snsName = UMShareToSina;
            break;
        case 1:
            snsName = UMShareToQQ;
            break;
        case 2:
            snsName = UMShareToWechatSession;
            break;
    }
    
    [ShareUtil umengOtherLoginWithLoginType:snsName presentingController:self callback:^(NSDictionary *result) {
        if (result)
        {
            [MBProgressHUD showStatus:@"Loading~~嘟嘟嘟..." toView:self.view];
            [self.httpUtil requestDic4MethodName:@"Auth/ThirdAuth" parameters:result result:^(NSDictionary *dic, int status, NSString *msg) {
                
                if (status == 1|| status == 2)
                {
                    User *userInfo = [User shareUser];
                    userInfo.Id = [dic valueForKey:@"Id"];
                    userInfo.nickName = [dic valueForKey:@"NickName"];
                    userInfo.userName = [dic valueForKey:@"UserName"];
                    userInfo.avatar = [dic valueForKey:@"Avatar"];
                    userInfo.mobile = [dic valueForKey:@"Mobile"];
                    userInfo.realName = [dic valueForKey:@"RealName"];
                    userInfo.password =  [dic valueForKey:@"Password"];
                    userInfo.isOtherLogin = YES;
//                    _otherLoginPassword = [dic valueForKey:@"Password"];
                    NSMutableDictionary *otherLoginResult = [NSMutableDictionary dictionaryWithDictionary:result];
                    [otherLoginResult removeObjectForKey:@"NickName"];
                    [otherLoginResult removeObjectForKey:@"Avatar"];
                    if (snsName == UMShareToWechatSession)
                    {
                        [otherLoginResult setValue:[dic valueForKey:@"OpenId"] forKey:@"OpenId"];
                        [otherLoginResult setValue:@"0" forKey:@"UnionId"];
                    }
                    userInfo.otherLoginResult = otherLoginResult;
                    [JPUSHService setTags:[NSSet setWithObject:@"all"] aliasInbackground:userInfo.userName];
                    [self hxLoginWithUsername:userInfo.userName password:userInfo.password];
                }
                else
                {
                    [[User shareUser] clearData];
                    [MBProgressHUD dismissHUDForView:self.view withError:msg];
                }
                
            }];
        }
        else
        {
            [[User shareUser] clearData];
            [MBProgressHUD showError:@"与阿么失之交臂啊，再登录看看" toView:self.view];
        }
    }];
}

- (void)doRegister:(id)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController: vc animated:YES];
}

#pragma mark - Request
- (void)requestLoginWithPhoneNum:(NSString *)phoneNum veriCode:(NSString *)veriCode
{
    [MBProgressHUD showStatus:@"正在登录..." toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Auth/MobileLogin" parameters:@{@"Mobile":phoneNum,@"Code":veriCode} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1)
         {
             User *user = [User shareUser];
             user.Id = [dic valueForKey:@"Id"];
             user.nickName = [dic valueForKey:@"NickName"];
             user.avatar = [dic valueForKey:@"Avatar"];
             user.password =  [dic valueForKey:@"Password"];
             user.mobile = [dic valueForKey:@"Mobile"];
             user.userName = [dic valueForKey:@"UserName"];
             user.realName = [dic valueForKey:@"RealName"];
             user.isOtherLogin = NO;
             [self hxLoginWithUsername:user.userName password:user.password];
         }
         else
         {
             // 我们登录失败 退出环信
             [[User shareUser] clearData];
             [MBProgressHUD dismissHUDForView:self.view withError:msg];
             [self stopTimer];
         }
    }];
}

- (void)delayDismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EaseLogin
- (void)hxLoginWithUsername:(NSString *)username password:(NSString *)password
{
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             
             User *userInfo = [User shareUser];
             [userInfo saveUser];
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
             [[EaseMob sharedInstance].chatManager disableAutoLogin];
             [[EaseMob sharedInstance].chatManager setApnsNickname:userInfo.nickName];
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             [[ApplyViewController shareController] loadDataSourceFromLocalDB];
             //发送自动登陆状态通知
             [self saveLastLoginUsername];
             //保存最近一次登录用户名
             [MBProgressHUD dismissHUDForView:self.view withSuccess:@"么么哒，见到阿么开心么！"];
             [self delayDismissViewController];
             
             // 发一个通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeiProject" object:nil];
             
             // 更新好友列表
//             [self requestUpdateFirendList];
//             [self performSelector:@selector(delayDismissViewController) withObject:nil afterDelay:1.5];
         }
         else
         {
             [[User shareUser] clearData];;
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     
                     [MBProgressHUD dismissHUDForView:self.view withError:[NSString stringWithFormat:@"%@",error.description]];
                     break;
                 case EMErrorNetworkNotConnected:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"网络未连接!"];
                     break;
                 case EMErrorServerNotReachable:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"服务器累了，休息一会儿~阿么给你捶捶肩"];
                     break;
                 case EMErrorServerAuthenticationFailure://获取token失败(Ex. 登录时用户名密码错误，或者服务器无法返回token)
                     [MBProgressHUD dismissHUDForView:self.view withError:@"服务器累了，休息一会儿~阿么给你捶捶肩"];
                     break;
                 case EMErrorServerTimeout:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"服务器累了，休息一会儿~阿么给你捶捶肩"];
                     break;
                 case 1009:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"账户已存在，请尝试登录"];
                     [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                         
                     } onQueue:nil];
                     break;

                 default:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"与阿么失之交臂啊，再登录看看"];
                     break;
             }
             [self stopTimer];
         }
     } onQueue:nil];
}

//- (void)requestUpdateFirendList
//{
//    [[NetWorkingUtil netWorkingUtil] requestArr4MethodName:@"Friend/List" parameters:@{@"PageIndex":@1,@"PageSize":@1000} result:^(NSArray *arr, int status, NSString *msg)
//     {
//         if (status == 1)
//         {
//             if (arr.count)
//             {
//                 [ChatFriendDAO updateChatFriends:arr];
//             }
//         }
//         else
//         {
//             if (![msg isEqualToString:@"操作成功"])
//             {
//                 [MBProgressHUD showError:msg toView:self.view];
//             }
//         }
//     } convertClassName:@"PSBuddy" key:@"DataSet"];
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EaseMob sharedInstance].chatManager setApnsNickname:nameTextField.text];
        }
    }
}

#pragma  mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneNumTextField) {
        [_phoneNumTextField resignFirstResponder];
        [_veriCodeTextField becomeFirstResponder];
    } else if (textField == _veriCodeTextField) {
        [_veriCodeTextField resignFirstResponder];
    }
    return YES;
}

- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end
