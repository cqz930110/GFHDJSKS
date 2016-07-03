//
//  PersonalSetViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "PersonalSetViewController.h"
#import "AccountSetTableViewCell.h"
#import "CheckNameViewController.h"
#import "BindingIphoneViewController.h"
#import "ModifyLoginPsdViewController.h"
#import "IphoneBindingViewController.h"
#import "User.h"

@interface PersonalSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personalSetTableView;
@property (nonatomic,strong)NSDictionary *personalDic;

@end

@implementation PersonalSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self backBarItem];
    [self setTabelViewInfo];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getPersonalData];
}

- (void)getPersonalData
{
    [self.httpUtil requestDic4MethodName:@"Personal/Setting" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg)
    {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            _personalDic = dic;
            if (![[_personalDic objectForKey:@"IdNumber"] isEqual: @""])
            {
                User *user = [User shareUser];
                user.realName = [NSString stringWithFormat:@"%@",[_personalDic objectForKey:@"IdNumber"]];
                [user saveUser];
            }
            [_personalSetTableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
    }];
}

- (void)setTabelViewInfo
{
    _personalSetTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_personalSetTableView registerNib:[UINib nibWithNibName:@"AccountSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountSetTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_personalDic objectForKey:@"IsThirdPartyLogin"] intValue] == 1) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AccountSetTableViewCell";
    AccountSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AccountSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.accountNameLab.text = @"实名认证";
        if ([[_personalDic objectForKey:@"IdNumber"] isEqual: @""]) {
            cell.accountInfoLab.text = @"未认证";
        }else{
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@**",[[User shareUser].realName substringToIndex:1]];
        }
    }else if (indexPath.row == 1){
        cell.accountNameLab.text = @"手机绑定";
        if ([[_personalDic objectForKey:@"Mobile"] isEqual: @""]) {
            cell.accountInfoLab.text = @"未绑定";
        }else{
            cell.accountInfoLab.text = [[_personalDic objectForKey:@"Mobile"]stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }else if (indexPath.row == 2){
        cell.accountNameLab.text = @"修改登录密码";
        cell.accountInfoLab.text = @"修改";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([[_personalDic objectForKey:@"IdNumber"] isEqual: @""]){
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
    }else if (indexPath.row == 1){
        if ([[_personalDic objectForKey:@"Mobile"] isEqual: @""]) {
            IphoneBindingViewController *iphoneBindingVC = [[IphoneBindingViewController alloc] init];
            [self.navigationController pushViewController:iphoneBindingVC animated:YES];
        }else{
            BindingIphoneViewController *bindingIphoneVC = [[BindingIphoneViewController alloc] init];
            bindingIphoneVC.mobile = [_personalDic objectForKey:@"Mobile"];
            [self.navigationController pushViewController:bindingIphoneVC animated:YES];
        }
    }else if (indexPath.row == 2){
        ModifyLoginPsdViewController *modifyLoginVC = [[ModifyLoginPsdViewController alloc] init];
        [self.navigationController pushViewController:modifyLoginVC animated:YES];
        
    }
}

@end
