//
//  MyCenterViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/23.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyCenterViewController.h"
#import "PSBarButtonItem.h"
#import "PersonalSetViewController.h"
#import "BaseDataViewController.h"
#import "AccountSetTableViewCell.h"
#import "SetMoreViewController.h"
#import "AccountManageViewController.h"
#import "FundManageViewController.h"
#import "ExpressAddressViewController.h"
#import "MyInvestProjectViewController.h"
#import "MyStartProjectViewController.h"
#import "AppDelegate.h"
#import "NSString+Adding.h"
#import "AddExpressAddressViewController.h"
#import "CheckNameViewController.h"
#import "IphoneBindingViewController.h"
#import "BindingIphoneViewController.h"
#import "User.h"
#import "MyDraftViewController.h"
#import "MyCollectViewController.h"
#import "SystemNotificationViewController.h"


@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLab;
@property (weak, nonatomic) IBOutlet UITableView *myCenterTableView;
@property (nonatomic,strong)NSDictionary *myCenterDic;

//  暂时这样解决
@property (nonatomic,assign)NSInteger indexNumber;
@property (nonatomic,assign)BOOL firstEnter;
@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewInfo];
    
    _firstEnter = YES;
    _myIconImageView.layer.cornerRadius = _myIconImageView.width * 0.5;
    _myIconImageView.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
  
    
}

- (void)setTableViewInfo
{
    _myCenterTableView.tableHeaderView = self.headerTableView;
    _myCenterTableView.tableFooterView = [UIView new];
    [_myCenterTableView registerNib:[UINib nibWithNibName:@"AccountSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountSetTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    if (_firstEnter) {
        _indexNumber = 8;
        _firstEnter = NO;
    }else{
        _indexNumber = 4;
    }
    [self getCenterDataInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNaviInfo];
    [self setBarButtonItems];
}

- (void)setBarButtonItems
{
    UIBarButtonItem *myButton1 = [[UIBarButtonItem alloc]
                                  initWithTitle:@"消息 "
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(messageClick)];
    myButton1.width = 40;
    [myButton1 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    
    UIBarButtonItem *myButton2 = [[UIBarButtonItem alloc]
                                  initWithTitle:@""
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:nil];
    myButton2.width = 60;
    [myButton2 setTintColor:[UIColor clearColor]];
    myButton2.enabled = NO;
    self.tabBarController.navigationItem.rightBarButtonItems = @[myButton1,myButton2];
}

- (void)getCenterDataInfo
{
    [self.httpUtil requestDic4MethodName:@"User/Index" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _myCenterDic = dic;
//            NSLog(@"------%@",_myCenterDic);
            [NetWorkingUtil setImage:_myIconImageView url:[_myCenterDic objectForKey:@"Avatar"] defaultIconName:@"home_默认"];
            _myNameLab.text = IsStrEmpty([_myCenterDic valueForKey:@"NickName"])?[_myCenterDic valueForKey:@"UserName"]:[_myCenterDic valueForKey:@"NickName"];
            [_myCenterTableView reloadData];
            
            if (![[dic objectForKey:@"RealName"] isEqual: @""])
            {
                User *user = [User shareUser];
                user.realName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RealName"]];
                [user saveUser];
            }
            else
            {
                User *user = [User shareUser];
                user.realName = @"";
                [user saveUser];
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)setNaviInfo
{
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)messageClick
{
    SystemNotificationViewController *systemVC = [SystemNotificationViewController new];
    [self.navigationController pushViewController:systemVC animated:YES];
}

- (IBAction)iconBtnClick:(id)sender {
    BaseDataViewController *baseDataVC = [[BaseDataViewController alloc] init];
    [self.navigationController pushViewController:baseDataVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AccountSetTableViewCell";
    AccountSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AccountSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.accountNameLab.text = @"余额";
            NSString *amountStr = [NSString stringWithFormat:@"%.2f",[[_myCenterDic objectForKey:@"Balance"] doubleValue]];
            cell.accountInfoLab.text = [NSString stringWithFormat:@"¥%@",[amountStr strmethodComma]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }else if (indexPath.row == 1){
            cell.accountNameLab.text = @"实名认证";
            if ([[_myCenterDic objectForKey:@"RealName"] isEqual:@""]){
                cell.accountInfoLab.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
                cell.accountInfoLab.text = @"未认证";
            }else if (_myCenterDic.count != 0){
                cell.accountInfoLab.text = [NSString stringWithFormat:@"%@**",[[User shareUser].realName substringToIndex:1]];
            }
        }else if (indexPath.row == 2)
        {
            cell.accountNameLab.text = @"手机绑定";
            if ([[_myCenterDic objectForKey:@"Mobile"] isEqual: @""])
            {
                cell.accountInfoLab.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
                cell.accountInfoLab.text = @"未绑定";
            }
            else
            {
                cell.accountInfoLab.text = [[_myCenterDic objectForKey:@"Mobile"]stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            cell.accountNameLab.text = @"我发起的项目";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"PublishedCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }else if (indexPath.row == 1){
            cell.accountNameLab.text = @"我支持的项目";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"SupportedCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }else if (indexPath.row == 2){
            cell.accountNameLab.text = @"我收藏的项目";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"FavoritedCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }else if (indexPath.row == 3){
            cell.accountNameLab.text = @"我的草稿";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"DroftedCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            cell.accountNameLab.text = @"银行卡管理";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"BankcardCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }else if (indexPath.row == 1){
            cell.accountNameLab.text = @"地址管理";
            cell.accountInfoLab.text = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"AddressCount"]];
            if (_myCenterDic.count == 0) {
                cell.accountInfoLab.text = @" ";
            }
        }
    }else if (indexPath.section == 3){
        cell.accountNameLab.text = @"设置";
        cell.accountInfoLab.text = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            FundManageViewController *vc = [[FundManageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1)
        {
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            if (_myCenterDic.count != 0) {
                checkNameVC.userStr = [NSString stringWithFormat:@"%@**",[[User shareUser].realName substringToIndex:1]];
                checkNameVC.idStr = [NSString stringWithFormat:@"%@",[_myCenterDic objectForKey:@"IdNumber"]];
            }
            
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            if ([[_myCenterDic objectForKey:@"Mobile"] isEqual: @""]) {
                IphoneBindingViewController *iphoneBindingVC = [[IphoneBindingViewController alloc] init];
                [self.navigationController pushViewController:iphoneBindingVC animated:YES];
            }else{
                BindingIphoneViewController *bindingIphoneVC = [[BindingIphoneViewController alloc] init];
                bindingIphoneVC.mobile = [_myCenterDic objectForKey:@"Mobile"];
                [self.navigationController pushViewController:bindingIphoneVC animated:YES];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            MyStartProjectViewController *myStartProjectVC = [[MyStartProjectViewController alloc] init];;
            [self.navigationController pushViewController:myStartProjectVC animated:YES];
        }else if (indexPath.row == 1){
            MyInvestProjectViewController *myInvestProjectVC = [[MyInvestProjectViewController alloc] init];
            [self.navigationController pushViewController:myInvestProjectVC animated:YES];
        }else if (indexPath.row == 2){
            MyCollectViewController *myCollectVC = [[MyCollectViewController alloc] init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }else if (indexPath.row == 3){
            MyDraftViewController *myDraftVC = [[MyDraftViewController alloc] init];
            [self.navigationController pushViewController:myDraftVC animated:YES];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            AccountManageViewController *accountManageVC = [[AccountManageViewController alloc] init];
            [self.navigationController pushViewController:accountManageVC animated:YES];
        }else if (indexPath.row == 1){
            if ([[_myCenterDic objectForKey:@"AddressCount"] intValue] == 0) {
                ExpressAddressViewController *vc = [[ExpressAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:NO];
                AddExpressAddressViewController *addExpressVC = [[AddExpressAddressViewController alloc] init];
                addExpressVC.type = @"添加";
                [self.navigationController pushViewController:addExpressVC animated:YES];
            }else{
                ExpressAddressViewController *vc = [[ExpressAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.section == 3){
        SetMoreViewController *setMoreVC = [[SetMoreViewController alloc]init];
        [self.navigationController pushViewController:setMoreVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
