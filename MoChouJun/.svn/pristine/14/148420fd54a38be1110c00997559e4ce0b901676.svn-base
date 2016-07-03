//
//  AddZhifubaoViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/7.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AddZhifubaoViewController.h"
#import "User.h"

@interface AddZhifubaoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zhifubaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *againzhifubaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *zhifubaoNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation AddZhifubaoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"支付宝添加";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _saveBtn.layer.cornerRadius = 5.0f;
    _saveBtn.userInteractionEnabled = NO;
    
    [_zhifubaoTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_againzhifubaoTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _zhifubaoNameTextField.userInteractionEnabled = NO;
    _zhifubaoNameTextField.text = [User shareUser].realName;
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_zhifubaoTextField.text)) {
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        _saveBtn.userInteractionEnabled = NO;
    }else if (IsStrEmpty(_againzhifubaoTextField.text)){
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        _saveBtn.userInteractionEnabled = NO;
    }else{
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#B37DD4"];
        _saveBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)saveBtnClick:(id)sender {
    
    if (![_zhifubaoTextField.text isEqual:_againzhifubaoTextField.text]) {
        [MBProgressHUD showMessag:@"两次输入的账户不一致"  toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Account/Add" parameters:@{@"TypeId":@(2),@"RealName":_zhifubaoNameTextField.text,@"AccountNum":_againzhifubaoTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
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

- (void)delayMethod
{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:NO];
    
}

@end
