//
//  MyStartSendGoodsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/23.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartSendGoodsViewController.h"
#import "ZHBPickerView.h"

@interface MyStartSendGoodsViewController ()<ZHBPickerViewDataSource,ZHBPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *expressNameLab;
@property (weak, nonatomic) IBOutlet UITextField *expressNumberTextField;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;
@property (nonatomic,strong)NSMutableArray *expressArr;
@property (nonatomic,strong)NSMutableArray *expressNameArr;
@property (nonatomic,assign)BOOL zhBPickBool;
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,assign)NSInteger expressId;
@end

@implementation MyStartSendGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self backBarItem];
    [self setupBarButtomItemWithImageName:@"nav_back_normal" highLightImageName:nil selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
    self.title = @"发货";
    _zhBPickBool = NO;
    _expressId = 0;
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    [self setInfo];
}

- (void)backClick
{
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getExpressNameDate];
}

- (void)setInfo
{
    _goodsInfoLab.text = [NSString stringWithFormat:@"收货信息:%@ %@",[_sendGoodsDic objectForKey:@"RecvName"],[_sendGoodsDic objectForKey:@"Mobile"]];
    _goodsNumberLab.text = [NSString stringWithFormat:@"数量:%@件",[_sendGoodsDic objectForKey:@"Count"]];
    _goodsAddressLab.text = [_sendGoodsDic objectForKey:@"AddressInfo"];
}

//   选择快递公司
- (IBAction)selectExpressBtnClick:(id)sender {
    [_expressNumberTextField resignFirstResponder];
    if (_zhBPickBool == NO) {
        _zhBPickBool = YES;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        [_window addSubview:_zhBPickerView];
    }else{
        _zhBPickBool = NO;
        [_zhBPickerView removeFromSuperview];
    }
}

//  确认
- (IBAction)commitBtnClick:(id)sender {
    
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
    [_expressNumberTextField resignFirstResponder];
    
    if ([_expressNameLab.text isEqual:@"请选择快递公司"]) {
        [MBProgressHUD showError:@"请先选择快递公司" toView:self.view];
        return;
    }
    
    if (IsStrEmpty(_expressNumberTextField.text)) {
        [MBProgressHUD showError:@"请填写快递单号" toView:self.view];
        return;
    }
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"User/AddExpress" parameters:@{@"SupportProjectId":[NSString stringWithFormat:@"%@",[_sendGoodsDic objectForKey:@"SupportProjectId"]],@"ExpressId":@(_expressId),@"ExpressNo":_expressNumberTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showSuccess:msg toView:self.view];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5f];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendGoods" object:nil];
            
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)getExpressNameDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"User/ExpressList" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            self.expressArr = [dic objectForKey:@"ExpressList"];
            for (NSDictionary *nameDic in _expressArr) {
                NSString *expressName = [nameDic objectForKey:@"Text"];
                [self.expressNameArr addObject:expressName];
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        return _expressNameArr;
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    _zhBPickBool = NO;
    _expressNameLab.text = content;
    [_expressNameLab setTextColor:[UIColor colorWithHexString:@"#181818"]];
    _expressNameLab.textAlignment = NSTextAlignmentLeft;
    if ([content isEqual:@""]) {
        _expressNameLab.text = _expressNameArr[6];
    }
    
    for (NSDictionary *expressNameDic in _expressArr) {
        if ([_expressNameLab.text isEqual:[expressNameDic objectForKey:@"Text"]]) {
            _expressId = [[expressNameDic objectForKey:@"Value"] integerValue];
        }
    }
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _zhBPickBool = NO;
    textField.textAlignment = NSTextAlignmentLeft;
    [_zhBPickerView removeFromSuperview];
}

- (NSMutableArray *)expressArr{
    if (!_expressArr) {
        _expressArr = [NSMutableArray array];
    }
    return _expressArr;
}

- (NSMutableArray *)expressNameArr{
    if (!_expressNameArr) {
        _expressNameArr = [NSMutableArray array];
    }
    return _expressNameArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
