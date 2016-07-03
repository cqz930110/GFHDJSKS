//
//  MyInvestDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MyInvestDetailsViewController.h"
#import "MyInvestDetailTableViewCell.h"
#import "SupportedProject.h"
#import "NSString+Adding.h"
#import "WeiProjectDetailsViewController.h"

@interface MyInvestDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myInvestDetailTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UIButton *begainBtn;
@property (strong, nonatomic) SupportedProject *detialSupportProject;// 用户本人投资的展示
@end

@implementation MyInvestDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投资详情";
    [self backBarItem];
    [self setTableViewInfo];
}

- (void)setTableViewInfo
{
    _myInvestDetailTableView.tableFooterView = _tableFooterView;
    [_myInvestDetailTableView registerNib:[UINib nibWithNibName:@"MyInvestDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInvestDetailTableViewCell"];
}

#pragma mark - Setter
- (void)setSupportProject:(SupportedProject *)supportProject
{
    _supportProject = supportProject;
    
    [self.httpUtil requestDic4MethodName:@"Support/View" parameters:@{@"Id":@(_supportProject.Id),@"SupportUserId":@(_supportProject.userId)} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            // 由于字段不统一，所以进行初始化操作
            _detialSupportProject = [[SupportedProject alloc] init];
            _detialSupportProject.profile = [dic valueForKey:@"Description"];
            _detialSupportProject.statusId = [[dic valueForKey:@"StatusId"] integerValue];
            _detialSupportProject.details = [dic valueForKey:@"Details"];
            _detialSupportProject.name = [dic valueForKey:@"ProjectName"];
            _detialSupportProject.mobile = [dic valueForKey:@"Mobile"];
            _detialSupportProject.showStatus = [dic valueForKey:@"ShowStatus"];
            _detialSupportProject.recvName = [dic valueForKey:@"RecvName"];
            _detialSupportProject.crowdFundId = [[dic valueForKey:@"CrowdFundId"] intValue];
            _detialSupportProject.Id = supportProject.Id;
            _detialSupportProject.amount = [[dic valueForKey:@"Amount"] doubleValue];
            _detialSupportProject.repayId = [[dic valueForKey:@"RepayId"] intValue];
            _detialSupportProject.userId = [[dic valueForKey:@"UserId"] intValue];
            _detialSupportProject.userNickname = [dic valueForKey:@"UserNickname"];
            _detialSupportProject.avatar = [dic valueForKey:@"UserAvatar"];
            
            
            if ([_fromStartProject isEqual:@"Cancel"] && _upStateProject == nil)
            {
                _detialSupportProject.statusId = 5;
            }
            
            [_myInvestDetailTableView reloadData];
            
            if (_detialSupportProject.statusId == 1)
            {
                _tableFooterView.hidden = NO;
            }
            else
            {
                _tableFooterView.hidden = YES;
            }
            
            if ([_fromStartProject isEqual:@"Cancel"] && _upStateProject == nil)
            {
                _tableFooterView.hidden = YES;
            }
            
            if ([_upStateProject isEqual:@"Cancel"])
            {
                _tableFooterView.hidden = YES;
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyInvestDetailTableViewCell";
    MyInvestDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        cell.myInvestNameLab.text = @"投资人";
        cell.myInvestDetailLab.text = _detialSupportProject.userNickname;
    }else if (indexPath.row == 1)
    {
        cell.myInvestNameLab.text = @"项目名称";
        cell.myInvestDetailLab.text = _detialSupportProject.name;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 2)
    {
        cell.myInvestNameLab.text = @"回报内容";
        cell.content = IsStrEmpty(_detialSupportProject.profile)?@"无":_detialSupportProject.profile;
        cell.myInvestDetailLab.text = cell.content;
    }else if (indexPath.row == 3)
    {
        cell.myInvestNameLab.text = @"支持金额";
        cell.myInvestDetailLab.text = [NSString stringWithFormat:@"¥%.2f",_detialSupportProject.amount];
        
    }else if (indexPath.row == 4){
        cell.myInvestNameLab.text = @"项目状态";
        cell.myInvestDetailLab.text = _detialSupportProject.showStatus;
    }else if (indexPath.row == 5)
    {
        cell.myInvestNameLab.text = @"收件人";
        cell.myInvestDetailLab.text = IsStrEmpty(_detialSupportProject.recvName)?@"无":_detialSupportProject.recvName;
        
    }else if (indexPath.row == 6)
    {
        cell.myInvestNameLab.text = @"电话号码";
        cell.myInvestDetailLab.text = IsStrEmpty(_detialSupportProject.mobile)?@"无":_detialSupportProject.mobile;
        
    }else if (indexPath.row == 7){
        cell.myInvestNameLab.text = @"收货地址";
        cell.content = IsStrEmpty(_detialSupportProject.details)?@"无":_detialSupportProject.details;
        cell.myInvestDetailLab.text = cell.content;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        CGFloat height = [IsStrEmpty(_detialSupportProject.profile)?@"无":_detialSupportProject.profile sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 105, 999)].height;
        return height<44?44:height;
    }
    else if (indexPath.row == 7)
    {
        CGFloat height = [_detialSupportProject.details sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 105, 999)].height;
        height += 20;
        return height<44?44:height;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 & indexPath.section == 0)
    {
        WeiProjectDetailsViewController *vc =[[WeiProjectDetailsViewController alloc] init];
        vc.projectId = _detialSupportProject.crowdFundId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action
- (IBAction)confirmReturnFund:(id)sender
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/ConfirmRepay" parameters:@{@"Id":@(_detialSupportProject.Id)} result:^(NSDictionary *dic, int status, NSString *msg){
        if (status == 2 || status == 1)
        {
            _supportProject.statusId = 2;
            _supportProject.showStatus = @"已回报";
            [self.delegate myInvestDetailsViewControllerDelegate:_supportProject];
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
