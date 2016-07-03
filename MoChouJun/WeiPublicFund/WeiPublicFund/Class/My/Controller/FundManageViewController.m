//
//  FundManageViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FundManageViewController.h"
#import "FundProgressView.h"
#import "FundBillViewController.h"

#import "CheckNameViewController.h"
#import "PayUtil.h"
#import "AccountManageViewController.h"
#import "RechargeViewController.h"
#import "NSString+Adding.h"
#import "WithdrawBankCardViewController.h"
#import "WXApi.h"
@interface FundManageViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet FundProgressView *fundProgressView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFundLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *yellowView;

@property (nonatomic,strong)NSDictionary *fundManageDic;

@property (assign, nonatomic) NSInteger userAuth;
@end

@implementation FundManageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资金管理";
    self.hideBottomBar = YES;
    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"资金明细" target:self action:@selector(fundListAction) leftOrRight:NO];
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    _redView.layer.cornerRadius = _redView.frame.size.width * 0.5;
    _yellowView.layer.cornerRadius = _yellowView.frame.size.width * 0.5;
    
    [self requestUserIDAuth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _fundManageDic = [NSDictionary dictionary];
    [self getFundManageDataInfo];
}

#pragma mark - Request
- (void)requestUserIDAuth
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Personal/CheckIDAuth" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.userAuth = [[dic objectForKey:@"IsValidated"] intValue];
            [MBProgressHUD dismissHUDForView:self.view];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)getFundManageDataInfo
{
    [self.httpUtil requestDic4MethodName:@"Fund/Index" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
           
            _fundManageDic = dic;
            NSLog(@"-------%@",_fundManageDic);
            _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[[_fundManageDic objectForKey:@"Balance"] doubleValue]];
            
            NSString *bottomBalanceStr = [NSString stringWithFormat:@"%.2f",[[_fundManageDic objectForKey:@"DiscretionaryAmount"] doubleValue]];
            _bottomBalanceLabel.text = [@"¥" stringByAppendingString:[bottomBalanceStr strmethodComma]];
            NSString *totalFundStr = [NSString stringWithFormat:@"%.2f",[[_fundManageDic objectForKey:@"LockAmount"] doubleValue]];
            _totalFundLabel.text = [@"¥" stringByAppendingString:[totalFundStr strmethodComma]];
            
            // fund progress
            NSNumber *u = [_fundManageDic objectForKey:@"Balance"];
            double uValue = [u doubleValue];
            NSNumber *u1 = [_fundManageDic objectForKey:@"LockAmount"];
            double u1Value = [u1 doubleValue];
            _fundProgressView.progress = uValue/u1Value*100;
            [_fundProgressView setNeedsDisplay];
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}


#pragma mark - Actions
- (void)fundListAction
{
    FundBillViewController *vc = [[FundBillViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)rechargeAction:(UIButton *)sender
{
    
    //如果没有微信 不让跳转

    if (self.userAuth == 1)
    {
//        if ([WXApi isWXAppInstalled])
//        {
        RechargeViewController *vc = [[RechargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            [MBProgressHUD showMessag:@"你的微信版本不支持充值！" toView:self.view];
//            return ;
//        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有实名认证,是否去实名认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (IBAction)withdrowMoneyAction:(UIButton *)sender {

    if (self.userAuth == 1) {
        WithdrawBankCardViewController *withdrawVC = [[WithdrawBankCardViewController alloc] init];
        
//        withdrawVC.bankCardEditStats =  [[_fundManageDic valueForKey:@"IsBindCard"] integerValue];
        withdrawVC.balance = [[_fundManageDic objectForKey:@"DiscretionaryAmount"] doubleValue];
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有实名认证,是否去实名认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
        [self.navigationController pushViewController:checkNameVC animated:YES];
    }
}


@end
