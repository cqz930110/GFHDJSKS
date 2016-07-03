//
//  WithdrawBankCardViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "WithdrawBankCardViewController.h"
#import "AddBankCardViewController.h"
#import "BankCard.h"
#import "OptionBankViewController.h"
#import "ValidateUtil.h"
#import "ReflectUtil.h"

@interface WithdrawBankCardViewController ()<OptionBankViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *bankTypeButton;
@property (weak, nonatomic) IBOutlet UIImageView *moreBankTypeImageView;
@property (weak, nonatomic) IBOutlet UIButton *withDrawButton;
@property (weak, nonatomic) IBOutlet UITextField *withdrawMoneyTextField;
@property (strong, nonatomic) BankCard *bankCard;
@end

@implementation WithdrawBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTextField];
    [self requestBankCard];
}

#pragma mark - OptionBankViewControllerDelegate
- (void)optionBankTypeUserInfo:(NSDictionary *)bankDic
{
    _bankTypeTextField.text = [bankDic objectForKey:@"BankName"];
    if (_bankCard)
    {
        _bankCard.bankTypeId = [[bankDic objectForKey:@"Id"] intValue];
    }
    else
    {
        _bankTypeTextField.tag = [[bankDic objectForKey:@"Id"] intValue];
    }
}

#pragma mark - Request
- (void)requestWithdraw
{
    NSDictionary *parmas;
    if (_bankCard)
    {
        parmas = @{@"UserAccountId":@(_bankCard.userAccountId),@"Amount":_withdrawMoneyTextField.text ,@"BankTypeId":@(_bankCard.bankTypeId),@"BankCardNo":_bankCard.accountNum};
    }
    else
    {
        parmas = @{@"UserAccountId":@"",@"Amount":_withdrawMoneyTextField.text ,@"BankTypeId":@(_bankTypeTextField.tag),@"BankCardNo":_bankNumTextField.text};
    }
    
    [MBProgressHUD showStatus:@"申请提现中..." toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Fund/Withdraw" parameters:parmas result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)requestBankCard
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Account/BankcardList" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        [hud hide:YES];
        if (status == 0 || status == -1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showError:msg toView:nil];
            return ;
        }
        
        if (status == 1)
        {
            // 有银行卡
            BankCard *bankCard = arr[0];
            if (!IsStrEmpty(bankCard.accountNum))
            {
                self.bankCard = bankCard;
            }
            else
            {
                _bankCard = nil;
            }
        }
    } convertClassName:@"BankCard" key:nil];
}

#pragma mark - Action
- (IBAction)optionBankType
{
    OptionBankViewController *vc = [[OptionBankViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)withdrawAction
{
    // 提现需要做判断
    
    if (_bankCard.accountNum.length < 13 &&  _bankNumTextField.text.length < 13)
    {
        [MBProgressHUD showMessag:@"银行卡输错了,要仔细啊"  toView:self.view];
        return;
    }
    
    if ([_withdrawMoneyTextField.text doubleValue] <= 0.0)
    {
        [MBProgressHUD showMessag:@"请输入正确提现金额!"  toView:self.view];
        _withdrawMoneyTextField.text = @"";
        return;
    }

    if (_balance < [_withdrawMoneyTextField.text doubleValue])
    {
        [MBProgressHUD showMessag:@"嘿,别贪心,余额可不够呢"  toView:self.view];
        _withdrawMoneyTextField.text = @"";
        return;
    }
    
    [self requestWithdraw];
}

- (void)textDidChange
{
    _withDrawButton.enabled = [self validateWithdraw];
}

#pragma mark - Setter

- (void)setBankCard:(BankCard *)bankCard
{
    _bankCard = bankCard;
    
    if (_bankCard.statusId == 1)
    {
        _bankNumTextField.userInteractionEnabled = NO;
        _bankNumTextField.text = _bankCard.transformAccountNum;
        _bankTypeTextField.text = _bankCard.bankName;
        _bankTypeButton.userInteractionEnabled = YES;
    }
    else if (_bankCard.statusId == 2)
    {
        _bankNumTextField.userInteractionEnabled = YES;
        _bankTypeButton.userInteractionEnabled = YES;
    }
    else if (_bankCard.statusId == 3)
    {
        _bankNumTextField.userInteractionEnabled = NO;
        _bankNumTextField.text = _bankCard.accountNum;
        _bankTypeTextField.text = _bankCard.bankName;
        _moreBankTypeImageView.hidden = YES;
        _bankTypeButton.userInteractionEnabled = NO;
    }
    else if (_bankCard.statusId == 4)
    {
        _bankNumTextField.userInteractionEnabled = NO;
        _bankNumTextField.text = _bankCard.transformAccountNum;
        _bankTypeTextField.text = _bankCard.bankName;
        _moreBankTypeImageView.hidden = YES;
        _bankTypeButton.userInteractionEnabled = NO;
    }
    else if (_bankCard.statusId == 5)
    {
        _bankNumTextField.userInteractionEnabled = YES;
        _bankNumTextField.text = _bankCard.accountNum;
        _bankTypeTextField.text = _bankCard.bankName;
        _bankTypeButton.userInteractionEnabled = YES;
    }
}

#pragma mark - Private
- (BOOL)validateWithdraw
{
    if (IsStrEmpty(_bankNumTextField.text)) return NO;
    if (IsStrEmpty(_bankTypeTextField.text)) return NO;
    if (IsStrEmpty(_withdrawMoneyTextField.text)) return NO;
    
    if ([_withdrawMoneyTextField.text doubleValue] <= 0.0)
    {
        return NO;
    }
    return YES;
}

- (void)setupNavi
{
    [self backBarItem];
    self.title = @"提现申请";
}

- (void)setupTextField
{
    [_withdrawMoneyTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    _withdrawMoneyTextField.placeholder = [NSString stringWithFormat:@"余额%.2f",_balance];
    [_bankNumTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
}

@end
