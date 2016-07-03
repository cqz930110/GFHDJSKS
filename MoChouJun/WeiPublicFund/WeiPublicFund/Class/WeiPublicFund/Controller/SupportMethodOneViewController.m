//
//  SupportMethodOneViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportMethodOneViewController.h"
#import "SupportMethodOneTableViewCell.h"
#import "PayUtil.h"
#import "User.h"
#import "JPUSHService.h"
#import "PayViewController.h"
#import "JDpayViewController.h"
#import "CheckNameViewController.h"
typedef NS_ENUM(NSInteger,PayType){
    PayTypeBalance,
    PayTypeWeiXin,
    PayTypeAliPay,
    PayTypeJDPay
};
@interface SupportMethodOneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *supportMethodTableView;

@property (nonatomic, assign) double balance;

@property (nonatomic,assign)PayType payType;

@property (assign, nonatomic) BOOL isInstallWeixin;
@end

@implementation SupportMethodOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支持方式";
    [self backBarItem];
    _isInstallWeixin = [WXApi isWXAppInstalled];

    [self setTabelView];
    [self requestUserBalance];
    
}

- (void)setTabelView
{
    _supportMethodTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [_supportMethodTableView registerNib:[UINib nibWithNibName:@"SupportMethodOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"SupportMethodOneTableViewCell"];
}

#pragma mark - Request
- (void)requestUserBalance
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Account/Center" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            _balance = [[dic valueForKey:@"Balance"] doubleValue];
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

#pragma mark - UITableViewDelegate & UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isInstallWeixin)
    {
        return 2;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SupportMethodOneTableViewCell";
    SupportMethodOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SupportMethodOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.supportMethodNameLab.text = @"账户余额";
        cell.supportMethodImageView.image = [UIImage imageNamed:@"pay"];
    }else if (indexPath.row == 1){
        cell.supportMethodNameLab.text = @"京东支付";
        cell.supportMethodImageView.image = [UIImage imageNamed:@"selected_jd"];
    }else if (indexPath.row == 2){
        cell.supportMethodNameLab.text = @"微信支付";
        cell.supportMethodImageView.image = [UIImage imageNamed:@"weixin-pay"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            _payType = PayTypeBalance;
            break;
        case 1:
            _payType = PayTypeJDPay;
            break;
        case 2:
            _payType = PayTypeWeiXin;
            break;
            default:
            return;
    }
    
    if (_payType == PayTypeJDPay)
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Personal/CheckIDAuth" parameters:@{} result:^(NSDictionary *dic, int status, NSString *msg) {
            
            if (status == 1 || status == 2)
            {
                [MBProgressHUD dismissHUDForView:self.view];
                if ([[dic valueForKey:@"IsValidated"] integerValue] == 1)
                {
                    JDpayViewController *vc= [[JDpayViewController alloc] init];
                    vc.parmas =  @{@"PayType":@(_payType),@"RepayId":@(0),@"Amount":_supportMount,@"CrowdFundId":@(_crowdFundId)};
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
    }
    else
    {
        [self requestSupportProject];
    }
}

- (void)requestSupportProject
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/Add" parameters:@{@"PayType":@(_payType),@"RepayId":@(0),@"Amount":_supportMount,@"CrowdFundId":@(_crowdFundId)} result:^(NSDictionary *dic, int status, NSString *msg){
        if (status == 1 || status == 2)
        {
            // 如果是余额
            if (_payType == 0)
            {
                [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
                
                // 设置 推送别名
                User *userInfo = [User shareUser];
                NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%d",_crowdFundId];// mochoujun_项目ID
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
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%d",_crowdFundId];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
        }
        else
        {
            [MBProgressHUD showError:@"支付没成功哦，求继续支持" toView:self.view];
        }
        
    }];
}

- (void)delayMethod
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
