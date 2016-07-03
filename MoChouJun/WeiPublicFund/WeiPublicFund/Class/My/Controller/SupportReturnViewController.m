//
//  MySupportPeopleViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportReturnViewController.h"
#import "SiteModel.h"
#import "FriendDetailViewController.h"
#import "MyInvestDetailsViewController.h"
#import "SupportedProject.h"
#import "ReturnSectionHeaderView.h"
#import "ReflectUtil.h"
#import "ProjectReturn.h"
#import "User.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "SupportReturn.h"
#import "SupportProjectTableViewCell.h"
#import "MySupportPeopleViewController.h"
#import "MyStartReturnObj.h"

@interface SupportReturnViewController ()<UITableViewDataSource,UITableViewDelegate,SupportProjectTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supportPeopleTableView;
@property (nonatomic,strong)NSMutableArray *supportPropleArr;
@property (strong, nonatomic) IBOutlet UIView *freeSupportView;
@property (weak, nonatomic) IBOutlet UILabel *freeSupportCountLabel;
@property (strong, nonatomic) SupportReturn *freeSupportReturn;
@end
static NSString *const supportProjectIden = @"SupportProjectTableViewCell";
@implementation SupportReturnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"回报列表";
    [self backBarItem];
    [self setTableViewInfo];
}

- (void)setTableViewInfo
{
    [_supportPeopleTableView registerNib:[UINib nibWithNibName:supportProjectIden bundle:nil] forCellReuseIdentifier:supportProjectIden];
}

- (IBAction)freeSupportPeopleDetail:(id)sender
{
    // 查看支持人员列表
    MySupportPeopleViewController *vc =[[MySupportPeopleViewController alloc] init];
    vc.startNoProjectArr = _freeSupportReturn.list;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SupportProjectTableViewCellDelegate
- (void)supportProjectCellReturnPeople:(SupportProjectTableViewCell *)cell
{
    [MBProgressHUD showStatus:@"正在操作中..." toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Repay/Confirm" parameters:@{@"Ids":@(cell.support.Id),@"CrowdFundId":@(_myStartReturn.Id)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"操作成功"];
            cell.support.StatusId = 2;
            cell.support.showStatus = @"回报中";
            NSIndexPath *path = [_supportPeopleTableView indexPathForCell:cell];
            [_supportPeopleTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            _myStartReturn.showStatus = @"回报中";
            _myStartReturn.statusId = 2;
            [self.delegate supportReturnStateDidChangeReturn:_myStartReturn];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _supportPropleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SupportReturn *support =  _supportPropleArr[indexPath.section];
    SupportProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:supportProjectIden forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.cellStyle = SupportProjectCellStyleReturn;
    cell.support = support;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     SupportReturn *support =  _supportPropleArr[indexPath.section];
    return [support contentHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 查看支持人员列表
    SupportReturn *support =  _supportPropleArr[indexPath.section];
    MySupportPeopleViewController *vc =[[MySupportPeopleViewController alloc] init];
    vc.startNoProjectArr = support.list;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request
- (void)getSupportPropleDataInfo
{
    [self.httpUtil requestArr4MethodName:@"Repay/SupList" parameters:@{@"CrowdFundId":@(_myStartReturn.Id)} result:^(NSArray *arr, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            [self.supportPropleArr addObjectsFromArray:arr];
            SupportReturn *supportReturn = [_supportPropleArr firstObject];
            
            if (supportReturn.supportAmount <= 0.0)
            {
                // 无偿回报界面
                _freeSupportReturn = supportReturn;
                _freeSupportCountLabel.text = [NSString stringWithFormat:@"%zd人已支持",_freeSupportReturn.list.count];
                _supportPeopleTableView.tableHeaderView = _freeSupportView;
                [_supportPropleArr removeObject:supportReturn];
            }
            
            [_supportPeopleTableView reloadData];
            
            if (_supportPropleArr.count == 0)
            {
                self.hideNoMsg = NO;
            }
            else
            {
                self.hideNoMsg = YES;
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:@"SupportReturn" key:nil];
}

#pragma mark - Setter & Getter
- (NSMutableArray *)supportPropleArr
{
    if (!_supportPropleArr)
    {
        _supportPropleArr = [NSMutableArray array];
    }
    return _supportPropleArr;
}

- (void)setMyStartReturn:(MyStartReturnObj *)myStartReturn
{
    _myStartReturn = myStartReturn;
    [self getSupportPropleDataInfo];
}


@end
