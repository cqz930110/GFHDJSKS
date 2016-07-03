//
//  RechargeViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/29.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "RechargedViewController.h"
#import "PayUtil.h"
#import "ReflectUtil.h"

#import "ValidateUtil.h"
#import "NSString+Adding.h"
#import "JDpayViewController.h"

@interface RechargedViewController ()//<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rechargeTypeButtons;
@property (weak, nonatomic) IBOutlet UITextField *rechargeNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (weak, nonatomic) IBOutlet UIImageView *bankCardImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rechargeViewHeightConstraint;

@property(assign,nonatomic) RechargeType rechargeType;
@property (weak, nonatomic) UIButton *optionRechargeButton;
@end

@implementation RechargedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"充值";
    [self backBarItem];
    
    // 判断是否安装微信
    if(![WXApi isWXAppInstalled])
    {
        UIButton * weixinButton = _rechargeTypeButtons[1];
        weixinButton.hidden = YES;
        
        UIButton * jdButton = _rechargeTypeButtons[0];
        jdButton.enabled = NO;
        self.rechargeType = RechargeTypeJDPay;
    }
    else
    {
        self.rechargeType = RechargeTypeWeixin;
    }
}

#pragma mark - Setter
- (void)setRechargeType:(RechargeType)rechargeType
{
    _rechargeType = rechargeType;
    switch (_rechargeType)
    {
        case RechargeTypeJDPay:
            _optionRechargeButton = _rechargeTypeButtons[0];
            break;
        case RechargeTypeWeixin:
            _optionRechargeButton = _rechargeTypeButtons[1];
            break;
    }
}

#pragma mark - Action
- (IBAction)textDidChange:(UITextField *)textField
{
    _rechargeButton.enabled = [textField.text doubleValue] > 0.0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField becomeFirstResponder];
    return YES;
}

#pragma mark - Actions
- (IBAction)optionRechargeAction:(UIButton *)sender
{
    
    _optionRechargeButton.enabled = YES;
    sender.enabled = NO;
    
    switch (sender.tag)
    {
        case RechargeTypeJDPay:
            self.rechargeType = RechargeTypeJDPay;
            break;
        case RechargeTypeWeixin:
            self.rechargeType = RechargeTypeWeixin;
            break;
    }
}

- (IBAction)rechargeAction:(UIButton *)sender
{
    // 判断充值金额
    if ([_rechargeNumTextField.text doubleValue] < 0.0)
    {
         [MBProgressHUD showMessag:@"请输入正确的充值金额 ！"  toView:self.view];
        return;
    }
    
    if (_rechargeType == RechargeTypeJDPay)
    {
        [self JDPay];
    }
    else
    {
        [self otherPay];
    }
}

// 京东支付
- (void)JDPay
{
    if ([_rechargeNumTextField.text doubleValue] <= 0.1) {
        [MBProgressHUD showMessag:@"充值金额必须大于0.1元" toView:self.view];
        return;
    }
    
    // 获取到URL
    JDpayViewController *vc= [[JDpayViewController alloc] init];
    vc.parmas = @{@"TypeId":@"3",@"TotalFee":_rechargeNumTextField.text};
    [self.navigationController pushViewController:vc animated:YES];
}

// 三方支付
- (void)otherPay
{
    // 重复点击
    _rechargeButton.userInteractionEnabled = NO;
    
    NSString *typeStr;
    BankPayType payType;
    switch (_rechargeType) {
        case RechargeTypeWeixin:
            typeStr = @"1";
            payType = BankPayTypeWeixinPay;
            break;
        default:
            break;
    }
    
    [self.httpUtil  requestDic4MethodName:@"Fund/Recharge" parameters:@{@"TypeId":typeStr,@"TotalFee":_rechargeNumTextField.text,@"BankCardNo":@""} result:^(NSDictionary *dic, int status, NSString *msg) {
         _rechargeButton.userInteractionEnabled = YES;
        if (status == 1 || status == 2)
        {
            [[PayUtil payUtil] payWithType:payType viewController:self param:dic completion:^(BOOL isSuccess) {
                //支付结果
                if (isSuccess)
                {
                    [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [MBProgressHUD showError:@"支付失败" toView:self.view];
                }
            }];
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];

}

@end
