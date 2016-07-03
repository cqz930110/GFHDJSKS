//
//  PayViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/2/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "PayViewController.h"
#import "BankCard.h"
#import "PayUtil.h"
#import "JPUSHService.h"
#import "ValidateUtil.h"
#import "NSString+Adding.h"

@interface PayViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankCardIdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) BankCard *bankCard;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连连支付";
    [self backBarItem];
    [self requestUserBankCardInfo];
    
}

- (BOOL)validateClikeConfirmButton
{
    if (_bankCardIdTextField.text.length > 0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Actions
- (IBAction)textFieldDidChange
{
    _confirmButton.enabled = [self validateClikeConfirmButton];
}

- (IBAction)confirmAction
{
    [self.view endEditing:YES];

    if (_bankCardIdTextField.userInteractionEnabled == YES)
    {
        // 绑定银行卡提示
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该银行卡将被绑定！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    else
    {
        [self requestSupportProject];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        [self requestSupportProject];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField  resignFirstResponder];
    return YES;
}

#pragma mark - Setter
- (void)setParmas:(NSDictionary *)parmas
{
    _parmas = parmas;
    _amountLabel.text = [NSString stringWithFormat:@"%@",_parmas[@"Amount"]];
}

#pragma mark - Pay
- (void)requestSupportProject
{
    _confirmButton.userInteractionEnabled = NO;
    
    NSMutableDictionary *pamars = [NSMutableDictionary dictionaryWithDictionary:_parmas];
    pamars[@"BankCardNo"] = _bankCardIdTextField.userInteractionEnabled?[_bankCardIdTextField.text stringByRemoveWhiteSpaceInString]: _bankCard.accountNum;
    
    //是否是回报ID
    if ([pamars[@"RepayId"] intValue] != 0)
    {
        pamars[@"Amount"] = @"0";
    }
    
    // 判断项目是否是回报
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/Add" parameters:pamars result:^(NSDictionary *dic, int status, NSString *msg){
        _confirmButton.userInteractionEnabled = YES;
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

#pragma mark - Request
// 上传BankCard
- (void)requestUploadBankCard
{
    [self.httpUtil requestDic4MethodName:@"Account/Add" parameters:@{@"TypeId":@"3",@"RealName":@"",@"BankTypeId":@"",@"OpenId":@"",@"AccountNum":[_bankCardIdTextField.text stringByRemoveWhiteSpaceInString],@"DistrictId":@"",@"BranchName":@"",@"BranchId":@""} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == -1 && status == 0) {
            [MBProgressHUD showError:msg toView:self.view];
        }
        else
        {
            _bankCardIdTextField.userInteractionEnabled = NO;
        }
    }];
}

- (void)requestUserBankCardInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Account/BankcardList" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (arr.count > 0)
            {
                // 有绑定银行卡
                _bankCard = arr[0];
                _bankCardIdTextField.text = _bankCard.transformAccountNum;
                _bankCardIdTextField.userInteractionEnabled = NO;
                [NetWorkingUtil setImage:_bankImageView url:_bankCard.bankIconUrl defaultIconName:nil];
                _confirmButton.enabled = YES;
            }
            [MBProgressHUD dismissHUDForView:self.view];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"BankCard" key:nil];
}

@end
