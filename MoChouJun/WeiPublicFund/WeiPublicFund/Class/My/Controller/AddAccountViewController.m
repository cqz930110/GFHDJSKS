//
//  AddAccountViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/7.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AddAccountViewController.h"
#import "AddAcountTableViewCell.h"
#import "AddWeiXinViewController.h"
#import "AddZhifubaoViewController.h"
#import "AddBankCardViewController.h"
#import "User.h"
#import "IphoneBindingViewController.h"
#import "CheckNameViewController.h"
#import "ShareUtil.h"

@interface AddAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addAccountTableView;
@property (nonatomic,strong)NSDictionary *checkIDAuthDic;
@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加";
    self.view.backgroundColor = [UIColor whiteColor];
    _checkIDAuthDic = [NSDictionary dictionary];
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [self getDataCheckIDAuth];
}

- (void)getDataCheckIDAuth
{
    [self.httpUtil requestDic4MethodName:@"Personal/CheckIDAuth" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _checkIDAuthDic = dic;
//            NSLog(@"-----%@",_checkIDAuthDic);
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)setTableViewInfo
{
    _addAccountTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_addAccountTableView registerNib:[UINib nibWithNibName:@"AddAcountTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddAcountTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AddAcountTableViewCell";
    AddAcountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AddAcountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row == 0) {
//        cell.addAccountNameLab.text = @"银行卡";
//        cell.addAccountImageView.image = [UIImage imageNamed:@"select_yu"];
//    }
    if (indexPath.row == 0){
        cell.addAccountNameLab.text = @"支付宝";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([User shareUser].mobile != nil ) {
        if ([[_checkIDAuthDic objectForKey:@"IsValidated"] intValue] == 1) {
//            if (indexPath.row == 0) {
//                AddBankCardViewController *addBankCardVC = [AddBankCardViewalloc] init];
//                [self.navigationController pushViewController:addBankCardVC animated:YES];
//            }
            //                    else if (indexPath.row == 1)
            //                    {
            //                        [self addWeChatAccount];
            //                    }
            if (indexPath.row == 0){
                AddZhifubaoViewController *addZhifubaoVC = [[AddZhifubaoViewController alloc] init];
                [self.navigationController pushViewController:addZhifubaoVC animated:YES];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有实名认证,是否去实名认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 20000;
            [alert show];
        }
    }else if ([User shareUser].mobile == nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有绑定手机,是否去绑定手机？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10000;
        [alert show];
    }
}

- (void)addWeChatAccount
{
    NSString *snsName = UMShareToWechatSession;

    [ShareUtil umengOtherLoginWithLoginType:snsName presentingController:self callback:^(NSDictionary *result) {
        if (result)
        {
            NSString *openId = [result valueForKey:@"OpenId"];
            NSString *userName = [result valueForKey:@"NickName"];
            [self.httpUtil requestDic4MethodName:@"Account/Add" parameters:@{@"TypeId":@"1",@"RealName":userName,@"OpenId":openId} result:^(NSDictionary *dic, int status, NSString *msg)
            {
                if (status == 1 || status == 2)
                {
                    [MBProgressHUD showSuccess:@"添加成功" toView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [MBProgressHUD showSuccess:@"添加失败" toView:self.view];
                }
            }];
        }
        else
        {
            [MBProgressHUD showError:@"添加微信账号失败..." toView:self.view];
        }
    }];
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            IphoneBindingViewController *iphoneBindingVC = [[IphoneBindingViewController alloc] init];
            [self.navigationController pushViewController:iphoneBindingVC animated:YES];
        }
    }else if (alertView.tag == 20000){
        if (buttonIndex == 1) {
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
