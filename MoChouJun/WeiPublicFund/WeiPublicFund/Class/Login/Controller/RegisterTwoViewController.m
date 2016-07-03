//
//  RegisterTwoViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "RegisterTwoViewController.h"
#import "ValidateUtil.h"
#import "User.h"
#import "IOSmd5.h"
#import "ApplyViewController.h"
#import "ProtocolViewController.h"
#import "JPUSHService.h"
@interface RegisterTwoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *setTextField;
@property (weak, nonatomic) IBOutlet UITextField *commitTextField;
@end

@implementation RegisterTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"设置密码";
    _commitBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)commitRegisterClick:(id)sender
{
    [_setTextField resignFirstResponder];
    [_commitBtn resignFirstResponder];
    if (IsStrEmpty(_setTextField.text))
    {
        [MBProgressHUD showMessag:@"请输入密码" toView:self.view];
        return ;
    }
    
    if (![ValidateUtil isValidateUserNameOrPassword:_setTextField.text])
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
    
    if (![_setTextField.text isEqualToString:_commitTextField.text])
    {
        [MBProgressHUD showMessag:@"两次密码输入不一致" toView:self.view];
        return ;
    }
    
    [_registerDic setValue:_setTextField.text forKey:@"Password"];
    
    [MBProgressHUD showStatus:@"正在注册中..." toView:self.view];
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"Auth/Register" parameters:_registerDic result:^(NSDictionary *dic, int status, NSString *msg)
    {
        button.userInteractionEnabled = YES;
        if (status == 1 || status == 2)
        {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            hud.detailsLabelText = @"注册成功,登录中...";
            
            [JPUSHService setTags:[NSSet setWithObject:@"all"] aliasInbackground:[_registerDic valueForKey:@"UserName"]];
            [self.httpUtil requestDic4MethodName:@"Auth/Login" parameters:@{@"UserName":[_registerDic valueForKey:@"UserName"],@"Password":[_registerDic valueForKey:@"Password"]} result:^(NSDictionary *dic, int status, NSString *msg) {
                
                if (status == 1)
                {
                    User *user = [User shareUser];
                    user.Id = [dic valueForKey:@"Id"];
                    user.nickName = [dic valueForKey:@"NickName"];
                    user.avatar = [dic valueForKey:@"Avatar"];
                    user.password = _setTextField.text;
                    user.mobile = [dic valueForKey:@"Mobile"];
                    user.userName = [dic valueForKey:@"UserName"];
                    user.realName = [dic valueForKey:@"RealName"];
                    user.isOtherLogin = NO;
                    
                    // 环信登录
                    NSString *passwordMD5;
                    passwordMD5 = [IOSmd5 md5:_setTextField.text];;
                    passwordMD5 = [IOSmd5 md5:passwordMD5];
                    [self loginWithUsername:user.userName password:passwordMD5];
                }
                else
                {
                    // 我们登录失败 退出环信
                    [MBProgressHUD dismissHUDForView:self.view withError:msg];
                }
            }];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissControllerAfterDelay
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EaseLogin
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    //    [[EaseMob sharedInstance].chatManager loginInfo];
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
             [MBProgressHUD dismissHUDForView:self.view withSuccess:@"登录成功！"];
             [self performSelector:@selector(dismissControllerAfterDelay) withObject:nil afterDelay:1.5];
         }
         else
         {
             User *userInfo = [User shareUser];
             [userInfo deleteUesr];
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     [MBProgressHUD dismissHUDForView:self.view withError:error.description];
                     break;
                 case EMErrorNetworkNotConnected:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"网络未连接!"];
                     break;
                 case EMErrorServerNotReachable:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"连接服务器失败!"];
                     break;
                 case EMErrorServerAuthenticationFailure:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"用户名或密码错误"];
                     break;
                 case EMErrorServerTimeout:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"连接服务器超时!"];
                     break;
                 case 1009:
                     [MBProgressHUD dismissHUDForView:self.view withError:@"账户已存在，请尝试登录"];
                     [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                         
                     } onQueue:nil];
                     break;
                     
                 default:
                     
                     [MBProgressHUD dismissHUDForView:self.view withError:@"登录失败"];
                     
                     break;
             }
         }
     } onQueue:nil];
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

- (IBAction)protocolBtnClick:(id)sender {
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

@end
