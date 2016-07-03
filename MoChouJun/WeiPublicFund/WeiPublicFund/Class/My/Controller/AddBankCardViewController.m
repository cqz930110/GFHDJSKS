//
//  AddBankCardViewController.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/14.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "OptionBankViewController.h"
#import "HWWeakTimer.h"
#import "ProvincesViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "RegisterBankViewController.h"
#import "User.h"


@interface AddBankCardViewController ()<UITextFieldDelegate,OptionBankViewControllerDelegate,RegisterBankViewControllerDelegate>
//{
//    NSInteger _time;//60
//}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *registerBankTextField;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic,strong)NSDictionary *bankAddressDic;

//@property (nonatomic , weak) NSTimer *timer;

@property (nonatomic,strong) NSMutableDictionary *addressDic;

@property (nonatomic,strong) NSDictionary *bankDic;
@property (nonatomic,strong) NSDictionary *registerDic;
@property (strong, nonatomic) District *district;
@end

@implementation AddBankCardViewController

- (NSDictionary *)registerDic
{
    if (!_registerDic) {
        _registerDic = [NSDictionary dictionary];
    }
    return _registerDic;
}

- (NSDictionary *)bankDic
{
    if (!_bankDic) {
        _bankDic = [NSDictionary dictionary];
    }
    return _bankDic;
}

- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}

- (void)updateAddress
{
    if ([[self.addressDic allKeys] containsObject:kDistrictKey])
    {
        District *district = [_addressDic valueForKey:kDistrictKey];
        if (_district.districtId == district.districtId) {
            return;
        }
        _district = district;
        Province *province =[_addressDic valueForKey:kProvincesKey];
        City *city = [_addressDic valueForKey:kCityKey];
        
        _addressLabel.textColor = Black575757;
        
        _addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province.provinceName,city.cityName,district.districtName];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _time = 60;
    [self setupNavi];
    
    _confirmButton.layer.cornerRadius = 5.0f;
    [_bankCardNumTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_registerBankTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
//    _nameLabel.text = [User shareUser].realName;
//    NSLog(@"------%@",[User shareUser].realName);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateAddress];
}

- (void)setupNavi
{
    self.title = @"添加银行卡";
    self.hideBottomBar = YES;
    [self backBarItem];
}

- (void)textFieldChange:(UITextField *)textField
{
    // 除了textFiled 还有 选择银行、选择地址、选择开户行 需要判断
    if (_bankCardNumTextField.text.length >= 19 ) {
        _bankCardNumTextField.text = [_bankCardNumTextField.text substringToIndex:19];
    }
    _confirmButton.userInteractionEnabled = [self canClikeConfirmButton];
}

- (BOOL)canClikeConfirmButton
{
    // 所在地 和开户行
    if (IsStrEmpty(_bankNameLabel.text)
        || IsStrEmpty(_bankCardNumTextField.text) || IsStrEmpty(_addressLabel.text) || IsStrEmpty(_registerBankTextField.text) || [_addressLabel.text isEqualToString:@"请选择所在地"])
    {
        _confirmButton.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        return NO;
    }
    _confirmButton.backgroundColor = [UIColor colorWithHexString:@"#B37DD4"];
    return YES;
}

#pragma mark - Actions
- (IBAction)optionBankType:(UIButton *)sender
{
    [self.view endEditing:YES];
    OptionBankViewController *vc = [[OptionBankViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)optionAdressLabel:(UIButton *)sender
{
    [self.view endEditing:YES];
    ProvincesViewController *provincesVC = [[ProvincesViewController alloc] init];
    provincesVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:provincesVC animated:YES];
}

- (IBAction)optionRegisterBank:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (_bankDic == nil) {
        [MBProgressHUD showMessag:@"请先选择银行" toView:self.view];
        return;
    }
    if (![[self.addressDic allKeys] containsObject:kDistrictKey]) {
        [MBProgressHUD showMessag:@"请先选择所在地" toView:self.view];
        return;
    }
    sender.userInteractionEnabled = NO;
    [self getRegisterBankDataWithSender:sender];
}

//- (IBAction)obtainTextCode:(UIButton *)sender
//{
//    [self.view endEditing:YES];
//    
//    _getCodeButton.userInteractionEnabled = NO;
//    // 判断手机号码 1.是否为空 2.是否是手机号码 3.是否需要判断注册
//    // 以上条件都满足 请求验证码 开启定时器
//    
//    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
//    _getCodeButton.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
//    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateDisabled];
//    
//    _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(obtainTextCodeTimeChange) userInfo:nil repeats:YES];
//    [_timer fire];
//}

//- (void)obtainTextCodeTimeChange
//{
//    _time --;
//    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
//    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateDisabled];
//    if (_time < 1)
//    {
//        _time = 60;
//        [_timer invalidate];
//        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        _getCodeButton.backgroundColor = [UIColor colorWithHexString:@"#06C1AE"];
//        _getCodeButton.userInteractionEnabled = YES;
//    }
//}

- (IBAction)confirmAction:(UIButton *)sender
{
    NSInteger registerId;
    if ([_registerDic objectForKey:@"Id"]) {
        registerId = [[_registerDic objectForKey:@"Id"] intValue];
    }else{
        registerId = 0;
    }
    if (IsStrEmpty(_registerBankTextField.text)) {
        [MBProgressHUD showMessag:@"请选择开户行或者输入" toView:self.view];
        return;
    }
    if (IsStrEmpty(_bankCardNumTextField.text)) {
         [MBProgressHUD showMessag:@"请输入银行卡卡号" toView:self.view];
        return;
    }
//    City *city;
    District *district;
    if ([[self.addressDic allKeys] containsObject:kDistrictKey])
    {
//        city = [_addressDic valueForKey:kCityKey];
        district = [_addressDic valueForKey:kDistrictKey];
    }else{
        return;
    }
    [MBProgressHUD showStatus:nil toView:nil];
    [self.httpUtil requestDic4MethodName:@"Account/Add" parameters:@{@"AccountNum":_bankCardNumTextField.text,@"BankTypeId":@([[_bankDic objectForKey:@"Id"] intValue]),@"BranchId":@(registerId),@"BranchName":_registerBankTextField.text,@"DistrictId":@(district.districtId),@"TypeId":@(3),@"RealName":[User shareUser].realName} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else{
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OptionBankViewControllerDelegate
- (void)optionBank:(NSDictionary *)bankDic
{
    _bankDic = bankDic;
    _bankNameLabel.textColor = [UIColor colorWithHexString:@"#575757"];
    _bankNameLabel.text = [_bankDic objectForKey:@"BankName"];
    _registerBankTextField.text = @"";
}
//RegisterBankViewControllerDelegate
- (void)registerBank:(NSDictionary *)registerbankDic
{
    _registerDic = registerbankDic;
    _registerBankTextField.text = [_registerDic objectForKey:@"BranchName"];
    _confirmButton.userInteractionEnabled = [self canClikeConfirmButton];
}

//选择开户行
- (void)getRegisterBankDataWithSender:(UIButton *)sender
{
    District *district = [_addressDic valueForKey:kDistrictKey];
    [self.httpUtil requestArr4MethodName:@"Bank/Branch" parameters:@{@"BankTypeId":@([[_bankDic objectForKey:@"Id"] intValue]),@"DistrictId":@(district.districtId)} result:^(NSArray *arr, int status, NSString *msg) {
        sender.userInteractionEnabled = YES;
        if (status == 1 || status == 2) {
            NSLog(@"======%@",arr);
            if (arr.count == 0) {
                [MBProgressHUD showError:@"没有所对应的开户行，请输入" toView:self.view];
            }else{
                RegisterBankViewController *registerBankVC = [[RegisterBankViewController alloc] init];
                registerBankVC.delegate = self;
                if ([[self.addressDic allKeys] containsObject:kDistrictKey])
                {
                    District *district = [_addressDic valueForKey:kDistrictKey];
                    registerBankVC.districtId = district.districtId;
                }
                registerBankVC.bankTypeId = [[_bankDic objectForKey:@"Id"] intValue];
                [self.navigationController pushViewController:registerBankVC animated:YES];
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:nil key:nil];
}
@end
