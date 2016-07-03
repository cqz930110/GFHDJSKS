//
//  GoSupportViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "GoSupportViewController.h"
#import "SupportMethodOneViewController.h"
#import "GoSupportViewCell.h"
#import "WXApi.h"
#import "User.h"
#import "JDpayViewController.h"
#import "PayUtil.h"
#import "JPUSHService.h"
#import "NSString+Adding.h"
#import "MMAlertView.h"

typedef NS_ENUM(NSInteger,PayType){
    PayTypeBalance = 0,
    PayTypeJDPay = 3,
    PayTypeWeixin = 1
};
@interface GoSupportViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *payTextField;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *goPayBtn;
@property (strong, nonatomic) IBOutlet UIView *tableFoorerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic,copy)NSString *balances;
@property (assign, nonatomic) PayType payType;
@property (assign, nonatomic) BOOL installWeixin;
@end

static NSString *cellIdentifier = @"GoSupportViewCell";
@implementation GoSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"支持";
    _goPayBtn.layer.cornerRadius = 5.0f;
    [self setupTableView];
    [self requsetUserBalances];
    
    _installWeixin = [WXApi isWXAppInstalled];
    
    [_payTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textDidChange
{
    if ([_payTextField.text integerValue] > 999999)
    {
        _payTextField.text = @"999999";
    }
}

- (void)setupTableView
{
    _tableView.tableHeaderView = self.tableHeaderView;
    _tableView.tableFooterView = self.tableFoorerView;
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_installWeixin)
    {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoSupportViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *title;
    NSString *imageName;
    switch (indexPath.row)
    {
        case 0:
            title  = [NSString stringWithFormat:@"余额支付(%@)",_balances];
            imageName = @"余额_select";
            break;
        case 1:
            title  = _installWeixin?@"微信支付":@"京东支付";
            imageName = _installWeixin?@"select_winxin.png":@"seletcted_jd";
            break;
        case 2:
            title  = @"京东支付";
            imageName = @"seletcted_jd";
            break;
    }
    [cell iconImageName:imageName title:title];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            _payType = PayTypeBalance;
            break;
        case 1:
            _payType = _installWeixin?PayTypeWeixin:PayTypeJDPay;
            break;
        case 2:
            _payType = PayTypeJDPay;
            break;
    }
}

- (IBAction)fundAlert
{
    
    NSString *content = @"1.平台只提供平台网络空间、技术服务和支持等中介服务。陌筹君作为居间方，并不是发起人或支持者中的任何一方，众筹仅存在于发起人和支持者之间，使用平台产生的法律后果由发起人与支持者自行承担。\r\n\n2. 项目筹款成功后，发放回报及其后续服务、开具发票等事项均由发起人负责。如果发生发起人无法发放回报、不提供回报后续服务等情况，您需要直接和发起人协商解决，陌筹君对此不承担任何责任。\r\n\n3. 由于发起人能力和经验不足、市场风险、法律风险等各种因素，众筹可能失败。如果众筹失败，您支持的款项会全部退回到您的平台账户中。\r\n\n4. 支持纯抽奖档位和无私支持档位，一旦支付成功将不予退款，众筹失败的除外。\r\n\n5. 若您选择纯抽奖档位（未中奖）或无私支持档位，项目筹款成功后发起人将不会给您发送回报。";
    
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    config.splitColor =  RGB(250, 250, 250);
    config.width = SCREEN_WIDTH - 40;
    config.detailFontSize = 12;
    config.innerMargin = 15;
    config.buttonHeight = 44;
    config.detailColor = Black737373;
    config.itemHighlightColor = [UIColor whiteColor];
    config.titleFontSize = 15;
    config.buttonFontSize = 14;
    
    MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"风险提示" detail:content items:@[MMItemMake(@"确定", MMItemTypeHighlight, nil)]];
    alertView.attachedView = self.view;
    UILabel *detailLabel = [alertView valueForKey:@"detailLabel"];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    UIView *buttonView = [alertView valueForKey:@"buttonView"];
    for (UIButton *subButton in buttonView.subviews)
    {
        [subButton setBackgroundImage:[UIImage mm_imageWithColor:RGB(241, 166, 65)] forState:UIControlStateNormal];
    }
    [alertView show];
}

#pragma mark - Actions
- (IBAction)goPayClick:(id)sender {
    
    [self.view endEditing:YES];
    if (IsStrEmpty(_payTextField.text)) {
        [MBProgressHUD showMessag:@"你想支持多少，要实打实的写上哦" toView:self.view];
        return;
    }

    if ([_payTextField.text doubleValue] < 0.09) {
        [MBProgressHUD showMessag:@"支持金额须大于0.1元！" toView:self.view];
        return;
    }
    
    if ([_payTextField.text integerValue] > 999999) {
        [MBProgressHUD showMessag:@"超过最大支持金额！" toView:self.view];
        return;
    }
    
    if (_payType == PayTypeBalance)
    {
        if ([_balances doubleValue] < [_payTextField.text doubleValue]) {
            [MBProgressHUD showMessag:@"余额不够啦，换个方式支持，或者充值也可以" toView:self.view];
            return;
        }
    }
    
    if (_payType == PayTypeJDPay)
    {
        [self JDPay];
    }
    else
    {
        [self requestSupportProject];
    }
}

#pragma mark - Pay
- (void)JDPay
{
    User *user = [User shareUser];
    if (user.realName.length != 0) {
        // 获取到URL
        NSString *remark = (_commentTextField.text.length == 0)?@"支持你，加油！":_commentTextField.text;
        
        JDpayViewController *vc= [[JDpayViewController alloc] init];
        vc.parmas =  @{@"PayType":@(_payType),@"RepayId":@(_repayId),@"Amount":_payTextField.text,@"CrowdFundId":@(_crowdFundId),@"Remark":[NSString encodeString:remark]};
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        // 没有实名认证
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有实名认证,是否去实名认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20000;
        [alert show];
    }
}

- (void)otherPayWithPayType:(NSInteger)payType pamar:(NSDictionary *)pamar
{
    [MBProgressHUD dismissHUDForView:self.view];
    BankPayType otherPayType = -1;
    //  0余额 1微信 2支付宝 代码来到这里只有微信支付
    switch (payType) {
        case 1:
            otherPayType = BankPayTypeWeixinPay;
            break;
        default:
            return;
    }
    
    [[PayUtil payUtil] payWithType:otherPayType viewController:self param:pamar completion:^(BOOL isSuccess) {
        //支付结果
        if (isSuccess)
        {
            [MBProgressHUD showSuccess:@"支持成功，感激涕零" toView:self.view];
            
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%zd",_crowdFundId];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD showError:@"支付没成功哦，求继续支持" toView:self.view];
        }
    }];
}

- (void)delayMethod
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Request
- (void)requsetUserBalances
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Account/Center" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:self.view];
            _balances = [NSString stringWithFormat:@"%.2f", [dic[@"Balance"] doubleValue]];
            [_tableView reloadData];
            _payType = PayTypeBalance;
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:2.5];
        }
    }];
}

- (void)requestSupportProject
{
    [MBProgressHUD showStatus:nil toView:self.view];
    NSString *remark = (_commentTextField.text.length == 0)?@"支持你，加油！":_commentTextField.text;
    
    [self.httpUtil requestDic4MethodName:@"Support/Add" parameters:@{@"PayType":@(_payType),@"RepayId":@(_repayId),@"Amount":_payTextField.text,@"CrowdFundId":@(_crowdFundId),@"Remark":[NSString encodeString:remark]} result:^(NSDictionary *dic, int status, NSString *msg){
        if (status == 1 || status == 2)
        {
            // 如果是余额
            if (_payType == PayTypeBalance)
            {
                [MBProgressHUD dismissHUDForView:self.view withSuccess:@"您已成功支付该项目"];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
                // 设置 推送别名
                User *userInfo = [User shareUser];
                NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%zd",_crowdFundId];// mochoujun_项目ID
                [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            }
            else
            {
                [self otherPayWithPayType:_payType pamar:dic];
            }
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)setCrowdFundId:(NSInteger)crowdFundId
{
    _crowdFundId = crowdFundId;
    if (_crowdFundId == 0) {
        _goPayBtn.userInteractionEnabled = NO;
        _goPayBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }else{
        _goPayBtn.userInteractionEnabled = YES;
    }
}

@end
