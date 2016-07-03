//
//  AddWeiXinViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/7.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AddWeiXinViewController.h"
#import "User.h"

@interface AddWeiXinViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
@property (weak, nonatomic) IBOutlet UITextField *againWeixinTextField;
@property (weak, nonatomic) IBOutlet UITextField *weixinNameTextField;

@end

@implementation AddWeiXinViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"微信添加";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _saveBtn.layer.cornerRadius = 5.0f;
    _saveBtn.userInteractionEnabled = NO;
    
    [_weixinTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_againWeixinTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _weixinNameTextField.userInteractionEnabled = NO;
    _weixinNameTextField.text = [User shareUser].realName;
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_weixinTextField.text)) {
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        _saveBtn.userInteractionEnabled = NO;
    }else if (IsStrEmpty(_againWeixinTextField.text)){
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        _saveBtn.userInteractionEnabled = NO;
    }else{
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#B37DD4"];
        _saveBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)saveBtnClick:(id)sender {
    
    if (![_weixinTextField.text isEqual:_againWeixinTextField.text]) {
        [MBProgressHUD showMessag:@"两次输入的账户不一致"  toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Account/Add" parameters:@{@"TypeId":@(1),@"RealName":_weixinNameTextField.text,@"AccountNum":_againWeixinTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:NO];
}
@end
