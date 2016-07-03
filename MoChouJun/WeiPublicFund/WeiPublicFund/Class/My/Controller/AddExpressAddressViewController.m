//
//  AddExpressAddressViewController.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "AddExpressAddressViewController.h"
#import "ProvincesViewController.h"
#import "ValidateUtil.h"
#import "ProvincesViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "Address.h"
#define defauleColor [UIColor colorWithHexString:@"#BBBBC0"]

@interface AddExpressAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *districtsLabel;// 区县
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailTextField;
@property (strong, nonatomic) District *district;
@property (nonatomic,strong) NSMutableDictionary *addressDic;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (nonatomic,assign)NSInteger switchNumber;
@end

@implementation AddExpressAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _switchNumber = 1;
    _nameTextField.text = _address.recvName;
    _mobileTextField.text = _address.mobile;
    _addressDetailTextField.text = _address.details;
    if (IsStrEmpty(_address.address)) {
        _districtsLabel.textAlignment = NSTextAlignmentRight;
        _districtsLabel.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
        _districtsLabel.text = @"请选择";
    }else{
        _districtsLabel.text = _address.address;
    }
    if (_address.statusId == 1) {
        [_mySwitch setOn: NO];
    }else if (_address.statusId == 2){
        [_mySwitch setOn: YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _district = [[District alloc] init];
    [self setupNavi];
    [self updateAddress];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updateAddress];
    [self.view endEditing:YES];
}

- (void)updateAddress
{
    NSLog(@"%@",self.addressDic);
    if ([[self.addressDic allKeys] containsObject:kDistrictKey])
    {
        Province *province =[_addressDic valueForKey:kProvincesKey];
        City *city = [_addressDic valueForKey:kCityKey];
        _district = [_addressDic valueForKey:kDistrictKey];
        _districtsLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province.provinceName,city.cityName,_district.districtName];
        _districtsLabel.textAlignment = NSTextAlignmentLeft;
        _districtsLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    }
}

- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}

- (void)setupNavi
{
    if ([_type isEqual:@"添加"]) {
        self.title = @"添加地址";
    }else{
        self.title = @"修改地址";
    }
    
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(finishEdit) leftOrRight:NO];
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}

- (void)backClick{
    if (!IsStrEmpty(_type)) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

- (BOOL)validateAll
{
    
    if(IsStrEmpty(_nameTextField.text))
    {
        [MBProgressHUD showMessag:@"记得填写收货人哦" toView:self.view];
        [_nameTextField becomeFirstResponder];
        return NO;
    }
    
    if(IsStrEmpty(_mobileTextField.text))
    {
        [MBProgressHUD showMessag:@"不填写手机号快递小哥找不到哟" toView:self.view];
        [_mobileTextField becomeFirstResponder];
        return NO;
    }
    
    if (![ValidateUtil isMobileNumber:_mobileTextField.text])
    {
        [MBProgressHUD showMessag:@"手机号码好像输错了,再试一次嘛" toView:self.view];
        [_mobileTextField becomeFirstResponder];
        return NO;
    }
    
    // 地区判断
    if (IsStrEmpty(_districtsLabel.text) || [_districtsLabel.text isEqualToString:@"请选择所在地区"])
    {
        [MBProgressHUD showMessag:@"所在的地区要记得填写哦~" toView:self.view];
        return NO;
    }
    
    // 判断详细地址
    if(IsStrEmpty(_addressDetailTextField.text))
    {
        [MBProgressHUD showMessag:@"还缺个信息的地址哟" toView:self.view];
        [_addressDetailTextField becomeFirstResponder];
        return NO;
    }
    
    if (_addressDetailTextField.text.length < 5) {
        [MBProgressHUD showMessag:@"详细地址,不得少于5个字" toView:self.view];
        return NO;
    }
    
    return YES;
}

- (void)requestAddressDetail
{
    [self.httpUtil requestDic4MethodName:@"Address/View" parameters:@{@"Id":@(_address.Id)} result:^(NSDictionary *dic, int status, NSString *msg)
     {
        if (status == -1 && status == 0)
        {
            [MBProgressHUD showError:msg toView:self.view];
        }else
        {
            
            _district.districtId = [[dic valueForKey:@"DistrictId"] integerValue];
            _districtsLabel.text = [dic valueForKey:@"DistrictName"];
        }
    }];
}
//  默认地址
- (IBAction)switchChangeClick:(id)sender {
    if (_mySwitch.isOn) {
        _switchNumber = 2;
    }else{
        _switchNumber = 1;
    }
}

#pragma mark - addAdress
- (void)finishEdit
{
    if ([self validateAll])
    {
        if (_mobileTextField.text.length != 11) {
            [MBProgressHUD showMessag:@"手机号码好像输错了,再试一次嘛" toView:self.view];
            return;
        }
        
        [self requestAddAddress];
    }
}

#pragma mark - Requeat
- (void)requestAddAddress
{
    [self setupBarButtomItemWithTitle:@"" target:self action:nil leftOrRight:NO];
    
    NSString *methodName = _address?@"Address/Edit":@"Address/Post";
    NSMutableDictionary *parma = [NSMutableDictionary dictionaryWithDictionary:@{@"RecvName":_nameTextField.text,@"Details":_addressDetailTextField.text,@"StatusId":@(_switchNumber),@"Mobile":_mobileTextField.text}];
    if (_address)
    {
        [parma setObject:@(_address.Id) forKey:@"Id"];
    }

    if (_district.districtId == 0) {
        [parma setObject:@(_address.districtId) forKey:@"DistrictId"];
    }else{
        [parma setObject:@(_district.districtId) forKey:@"DistrictId"];
    }
    [self.httpUtil requestDic4MethodName:methodName parameters:parma result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            NSString *showStr = _address?@"修改成功！":@"添加成功！";
            [MBProgressHUD showSuccess:showStr toView:self.view];
            if ([self.delegate respondsToSelector:@selector(callbackAddAdressId:)])
            {
                [self.delegate callbackAddAdressId:[[dic objectForKey:@"AddressId"] integerValue]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
            [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(finishEdit) leftOrRight:NO];
        }
    }];
}

- (IBAction)optionAddress:(UIButton *)sender
{
    ProvincesViewController *provincesVC = [[ProvincesViewController alloc] init];
    _addressDic = [NSMutableDictionary dictionary];
    provincesVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:provincesVC animated:YES];
}


@end
