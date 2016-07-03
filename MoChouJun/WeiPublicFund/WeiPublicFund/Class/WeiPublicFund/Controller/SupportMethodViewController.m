//
//  SupportMethodViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/17.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportMethodViewController.h"
#import "SupportMethodTableViewCell.h"
#import "SupportMethodTwoTableViewCell.h"
#import "ExpressAddressViewController.h"
#import "ReflectUtil.h"
#import "Address.h"
#import "PayUtil.h"
#import "NSString+Adding.h"
#import "User.h"
#import "JPUSHService.h"
#import "PayViewController.h"
#import "SupportReturn.h"
#import "JDpayViewController.h"
#import "CheckNameViewController.h"
#import "GoSupportViewCell.h"
#import "SupportAddressTableViewCell.h"
#import "MMAlertView.h"
#import "AddExpressAddressViewController.h"

typedef NS_ENUM(NSInteger,PayType){
    PayTypeBalance = 0,
    PayTypeJDPay = 3,
    PayTypeWeixin = 1
};
@interface SupportMethodViewController ()<UITableViewDataSource,UITableViewDelegate,JDpayViewControllerDelegate,ExpressAddressViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supportMethodTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *supportAmountLab;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UILabel *supportAmountOneLab;
@property (weak, nonatomic) IBOutlet UILabel *supportContentLab;
@property (weak, nonatomic) IBOutlet UILabel *supleNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *addNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLab;


@property (nonatomic,assign)PayType payType;
@property (nonatomic, assign) double balance;
@property (assign, nonatomic) BOOL installWeixin;
@property (copy, nonatomic) NSString *supportProjectId;

@property (nonatomic,assign)NSInteger userAddresId;
@property (nonatomic,strong)NSString *addressDetailsStr;
@end
static NSString *cellIdentifier = @"GoSupportViewCell";
static NSString *const supportProjectIden = @"SupportProjectTableViewCell";
static NSString *const supportAddressIden = @"SupportAddressTableViewCell";
@implementation SupportMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userAddresId = 0;
    _addressDetailsStr = @"";
    [self setupInit];
    [self setupTableView];
    [self requestUserBalance];
    [self setTableHeaderViewInfo];
     _supportAmountLab.text = [NSString stringWithFormat:@"¥ %.2f",_support.supportAmount];
    
    if (_addressDic) {
        _userAddresId = [[_addressDic objectForKey:@"Id"] integerValue];
        _addressDetailsStr =  IsStrEmpty([_addressDic objectForKey:@"Details"])?@"选择收货地址":[_addressDic objectForKey:@"Details"];
    }
}

- (void)setupInit
{
    [self backBarItem];
    self.title = @"支持方式";

    _payType = PayTypeBalance;
    _installWeixin = [WXApi isWXAppInstalled];
}

- (void)setupTableView
{
    [_supportMethodTableView registerNib:[UINib nibWithNibName:supportProjectIden bundle:nil] forCellReuseIdentifier:supportProjectIden];
    [_supportMethodTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [_supportMethodTableView registerNib:[UINib nibWithNibName:supportAddressIden bundle:nil] forCellReuseIdentifier:supportAddressIden];
    _supportMethodTableView.tableFooterView = self.tableFootView;
    _supportMethodTableView.tableHeaderView = self.tableHeaderView;
}

- (void)setTableHeaderViewInfo
{
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_support.supportAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _supportAmountOneLab.attributedText = atriText;
    
    _supportContentLab.text = _support.Description;
    
    if (_support.maxNumber == 0) {
        _supleNumberLab.text = [NSString stringWithFormat:@"不限制数量"];
    }else{
        _supleNumberLab.text = [NSString stringWithFormat:@"还剩%zd件",(_support.maxNumber - _support.supportCount)];
    }
    
    
    [self setTotalAmountLabText:[NSString stringWithFormat:@"支持金额：¥%.2f",_support.supportAmount]];
}

- (void)setTotalAmountLabText:(NSString *)str
{
    NSMutableAttributedString * atriAmountText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    [atriAmountText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#181818"] range:NSMakeRange(0, 5)];
    [atriAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(6, atriAmountText.length - 9)];
    _totalAmountLab.attributedText = atriAmountText;
}

//    减少
- (IBAction)reduceBtnClick:(id)sender {
    if ([_addNumberLab.text integerValue] > 1) {
        _addNumberLab.text = [NSString stringWithFormat:@"%ld",[_addNumberLab.text integerValue] - 1];
        [self setTotalAmountLabText:[NSString stringWithFormat:@"支持金额：¥%.2f",_support.supportAmount * [_addNumberLab.text integerValue]]];
        _supportAmountLab.text = [NSString stringWithFormat:@"¥ %.2f",_support.supportAmount * [_addNumberLab.text integerValue]];
    }
//    [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//   增加
- (IBAction)addBtnClick:(id)sender {
    NSInteger numberCount = 0;
    if (_support.maxNumber == 0) {
        numberCount = 99;
    }else{
        numberCount = _support.maxNumber - _support.supportCount;
    }
    if ([_addNumberLab.text integerValue] < numberCount) {
        _addNumberLab.text = [NSString stringWithFormat:@"%ld",[_addNumberLab.text integerValue] + 1];
        [self setTotalAmountLabText:[NSString stringWithFormat:@"支持金额：¥%.2f",_support.supportAmount * [_addNumberLab.text integerValue]]];
        _supportAmountLab.text = [NSString stringWithFormat:@"¥ %.2f",_support.supportAmount * [_addNumberLab.text integerValue]];
    }
//    [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Actions
- (IBAction)fundAlert
{
    NSString *content = @"1.平台只提供平台网络空间、技术服务和支持等中介服务。陌筹君作为居间方，并不是发起人或支持者中的任何一方，众筹仅存在于发起人和支持者之间，使用平台产生的法律后果由发起人与支持者自行承担。\r\n\n2. 项目筹款成功后，发放回报及其后续服务、开具发票等事项均由发起人负责。如果发生发起人无法发放回报、不提供回报后续服务等情况，您需要直接和发起人协商解决，陌筹君对此不承担任何责任。\r\n\n3. 由于发起人能力和经验不足、市场风险、法律风险等各种因素，众筹可能失败。如果众筹失败，您支持的款项会全部退回到您的平台账户中。\r\n\n4. 支持纯抽奖档位和无私支持档位，一旦支付成功将不予退款，众筹失败的除外。\r\n\n5. 若您选择纯抽奖档位（未中奖）或无私支持档位，项目筹款成功后发起人将不会给您发送回报。";
    
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    config.splitColor =  RGB(194, 139, 230);
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

#pragma mark - Pay
- (IBAction)paySupportClick:(id)sender {
    
    if (_support.isExpressed && _userAddresId == 0) {
        [MBProgressHUD showMessag:@"您还没有选择收货地址" toView:self.view];
        return;
    }
   
    double balance = _support.supportAmount;
    // 如果是余额 需要判断余额是否够用
    if (_payType == PayTypeBalance)
    {
        if (_balance < balance)
        {
            [MBProgressHUD showError:@"余额不够啦，换个方式支持，或者充值也可以" toView:self.view];
            return;
        }
    }
    NSString *remark = (_commentTextField.text.length == 0)?@"":_commentTextField.text;
    if (_payType == PayTypeJDPay)
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Personal/CheckIDAuth" parameters:@{} result:^(NSDictionary *dic, int status, NSString *msg) {
            
            if (status == 1 || status == 2)
            {
                [MBProgressHUD dismissHUDForView:self.view];
                if ([[dic valueForKey:@"IsValidated"] integerValue] == 1)
                {
                    // 获取到URL
                    JDpayViewController *vc= [[JDpayViewController alloc] init];
                    vc.delegate = self;
                    vc.parmas =  @{@"PayType":@(_payType),@"RepayId":@(_support.Id),@"Amount":@"",@"CrowdFundId":@(_support.crowdFundId),@"Remark":[NSString encodeString:remark]};
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
            else
            {
                [MBProgressHUD dismissHUDForView:self.view withError:msg];
                return ;
            }
        }];
        return;
    }
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/Add" parameters:@{@"PayType":@(_payType),@"RepayId":@(_support.Id),@"Amount":@"",@"CrowdFundId":@(_support.crowdFundId),@"Remark":[NSString encodeString:remark],@"Count":_addNumberLab.text,@"UserAddresId":@(_userAddresId)} result:^(NSDictionary *dic, int status, NSString *msg){
        if (status == 1 || status == 2)
        {
            _supportProjectId = [dic valueForKey:@"SupportProjectId"];
            // 如果是余额
            if (_payType == PayTypeBalance)
            {
                [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];

                // 设置 推送别名
                User *userInfo = [User shareUser];
                NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%@",@(_support.crowdFundId)];// mochoujun_项目ID
                [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
                [MBProgressHUD dismissHUDForView:self.view withSuccess:@"回报会很快飞向你~~"];
                [self performSelector:@selector(payComfirmBack) withObject:nil afterDelay:1.5];
               
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

- (void)otherPayWithPayType:(NSInteger)payType pamar:(NSDictionary *)pamar
{
    [MBProgressHUD dismissHUDForView:self.view];
    BankPayType otherPayType = -1;
    //  0余额 1微信 2支付宝
    switch (payType) {
        case 1:
            otherPayType = BankPayTypeWeixinPay;
            break;
            default:
            return;
    }
    
    if (otherPayType != BankPayTypeWeixinPay && otherPayType != BankPayTypeAliPay)
    {
        [MBProgressHUD showMessag:@"请选择支持方式" toView:self.view];
        return;
    }
    [[PayUtil payUtil] payWithType:otherPayType viewController:self param:pamar completion:^(BOOL isSuccess) {
        //支付结果
        if (isSuccess)
        {
            [MBProgressHUD showSuccess:@"支持成功，感激涕零" toView:self.view];
//            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%@",@(_support.crowdFundId)];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
            
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"回报会很快飞向你~~"];
            [self performSelector:@selector(payComfirmBack) withObject:nil afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD showError:@"支付没成功哦，求继续支持" toView:self.view];
        }
    }];
}

- (void)delayMethod
{
    NSArray *naviChilds = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:naviChilds[naviChilds.count - 3] animated:YES];
}

#pragma mark - JDpayViewControllerDelegate
- (void)jdPayFinishedSupportId:(NSString *)supportId
{
//    [MBProgressHUD dismissHUDForView:self.view withSuccess:@"回报会很快飞向你~~"];
//    [self performSelector:@selector(payComfirmBack) withObject:nil afterDelay:1.5];
}

#pragma mark - Request
- (void)requestUserBalance
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Account/Center" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            self.balance = [[dic valueForKey:@"Balance"] doubleValue];
            [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            _payType = PayTypeBalance;
            [_supportMethodTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
//#warning TODO - 操作失败 直接退出控制器
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:2.5];
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20000){
        if (buttonIndex == 1) {
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_support.isExpressed) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (_installWeixin)
        {
            return 3;
        }
        return 2;
    }else{
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50;
    }else{
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        GoSupportViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        NSString *title;
        NSString *imageName;
        if (indexPath.row == 0) {
            NSString *amountStr = [NSString stringWithFormat:@"余额支付(¥%.2f)",_balance];
            NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",amountStr] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            [atriText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, atriText.length - 4)];
            cell.titleLabel.attributedText = atriText;
            cell.iconImageView.image = [UIImage imageNamed:@"余额_select"];
        }else{
            switch (indexPath.row)
            {
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
        }
        return  cell;
    }else{
        SupportAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:supportAddressIden forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addressDetailsLab.text = _addressDetailsStr;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
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
    }else{
        if (IsStrEmpty([_addressDic objectForKey:@"Details"])) {
            ExpressAddressViewController *exPressAddressVC = [ExpressAddressViewController new];
            exPressAddressVC.clikeType = ExpressAddressClikeTypeBack;
            exPressAddressVC.delegate = self;
            [self.navigationController pushViewController:exPressAddressVC animated:NO];
            AddExpressAddressViewController *addExpressVC = [[AddExpressAddressViewController alloc] init];
            addExpressVC.type = @"添加";
            [self.navigationController pushViewController:addExpressVC animated:YES];
        }else{
            ExpressAddressViewController *exPressAddressVC = [ExpressAddressViewController new];
            exPressAddressVC.clikeType = ExpressAddressClikeTypeBack;
            exPressAddressVC.delegate = self;
            [self.navigationController pushViewController:exPressAddressVC animated:NO];
        }
        
    }
//    [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//  ExpressAddressViewControllerDelegate
- (void)optionExpressAddress:(Address *)address
{
    _userAddresId = address.Id;
    _addressDetailsStr = [NSString stringWithFormat:@"%@ %@",address.address,address.details];
    [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_supportMethodTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_supportMethodTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)payComfirmBack
{
    NSArray *childViewControllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:[childViewControllers objectAtIndex:1] animated:YES];
}

@end