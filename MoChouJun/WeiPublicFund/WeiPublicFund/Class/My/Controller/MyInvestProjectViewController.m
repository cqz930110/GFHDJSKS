//
//  MyInvestProjectViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MyInvestProjectViewController.h"
#import "MyInvestProjectTableViewCell.h"
#import "MyInvestDetailsViewController.h"
#import "SupportedProject.h"
#import "FriendDetailViewController.h"
#import "ReflectUtil.h"
#import "ExpressInfoViewController.h"
#import "WeiProjectDetailsViewController.h"
#import "SupportDetailsViewController.h"
#import "MyInvestCommitReturnViewController.h"

@interface MyInvestProjectViewController ()<UITableViewDelegate,UITableViewDataSource,MyInvestDetailsViewControllerDelegate,UIAlertViewDelegate>
{
    int _pageIndex;
    int _refreshNum;
}

@property (weak, nonatomic) IBOutlet UITableView *myInvestTableView;
@property (strong, nonatomic) NSMutableArray *myInvestList;
@property (assign, nonatomic) BOOL isRefreshEnd;
@end

@implementation MyInvestProjectViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我支持的项目";
    [self setupAllProperty];
    [self backBarItem];

    [self setTableViewInfo];

    [MBProgressHUD showStatus:nil toView:self.view];
    [self requestSupportPeopleList];
}

#pragma mark - Private
- (void)setupAllProperty
{
    _refreshNum = 10;
    _pageIndex = 1;
    _isRefreshEnd = NO;
}

- (void)setTableViewInfo
{
    [_myInvestTableView registerNib:[UINib nibWithNibName:@"MyInvestProjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInvestProjectTableViewCell"];
    _myInvestTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_myInvestTableView];
}

#pragma mark Request
- (void)requestSupportPeopleList
{
    [self.httpUtil requestDic4MethodName:@"User/SupportCf" parameters:@{@"PageSize":@(_refreshNum),@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        [_myInvestTableView.mj_footer endRefreshing];
        [_myInvestTableView.mj_header endRefreshing];
        if (status == 1 || status == 2)
        {
            if (_pageIndex == 1)
            {
                [_myInvestList removeAllObjects];
            }
            
            NSArray *arr = [ReflectUtil reflectDataWithClassName:@"SupportedProject" otherObject:[[dic valueForKey:@"List"] valueForKey:@"DataSet"] isList:YES];
            
            self.isRefreshEnd = _refreshNum > arr.count;
            [MBProgressHUD dismissHUDForView:self.view];
            [self.myInvestList addObjectsFromArray:arr];
            [_myInvestTableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if (_myInvestList.count == 0)
        {
            self.hideNoMsg = NO;
        }
        else
        {
            self.hideNoMsg = YES;
        }
    }];
}

#pragma mark - Refresh
- (void)footerRefreshloadData
{
    _pageIndex++;
    if (_myInvestTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        [self requestSupportPeopleList];
    }
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self requestSupportPeopleList];
}

#pragma mark - Setter
- (NSMutableArray *)myInvestList
{
    if (!_myInvestList)
    {
        _myInvestList = [NSMutableArray array];
    }
    return _myInvestList;
}

- (void)setIsRefreshEnd:(BOOL)isRefreshEnd
{
    _isRefreshEnd = isRefreshEnd;
    
    if (_isRefreshEnd)
    {
        [_myInvestTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_myInvestTableView.mj_footer resetNoMoreData];
    }
}

#pragma mark - MyInvestDetailsViewControllerDelegate
- (void)myInvestDetailsViewControllerDelegate:(SupportedProject *)supportProject
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[_myInvestList indexOfObject:supportProject]];
    [_myInvestTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return _myInvestList.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyInvestProjectTableViewCell";
    MyInvestProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyInvestProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.myIconBtn addTarget:self action:@selector(myIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.myIconBtn.tag = indexPath.section;
    [cell.expressBtn addTarget:self action:@selector(expressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.expressBtn.tag = indexPath.section;
    [cell.commitReturnBtn addTarget:self action:@selector(commitReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.commitReturnBtn.tag = indexPath.section;
    [cell.supportDetailsBtn addTarget:self action:@selector(supportDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.supportDetailsBtn.tag = indexPath.section;
    SupportedProject *supporyedProject = _myInvestList[indexPath.section];
    cell.supporyedProject = supporyedProject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MyInvestDetailsViewController *myInvestDetaiVC = [[MyInvestDetailsViewController alloc] init];
//    myInvestDetaiVC.delegate = self;
//    myInvestDetaiVC.supportProject = _myInvestList[indexPath.section];
//    [self.navigationController pushViewController:myInvestDetaiVC animated:YES];
    SupportedProject *supporyedProject = _myInvestList[indexPath.section];
    WeiProjectDetailsViewController *weiProjectVC = [WeiProjectDetailsViewController new];
    weiProjectVC.projectId = supporyedProject.crowdFundId;
    [self.navigationController pushViewController:weiProjectVC animated:YES];
}

//   快递信息
- (void)expressBtnClick:(UIButton *)sender
{
    SupportedProject *supporyedProject = _myInvestList[sender.tag];
    ExpressInfoViewController *expressInfoVC = [ExpressInfoViewController new];
    expressInfoVC.projectId = supporyedProject.crowdFundId;
    expressInfoVC.stateId = supporyedProject.statusId;
    [self.navigationController pushViewController:expressInfoVC animated:YES];
}

//  确认回报／删除
- (void)commitReturnBtnClick:(UIButton *)sender
{
    SupportedProject *supporyedProject = _myInvestList[sender.tag];
    if (supporyedProject.statusId == 2 || supporyedProject.statusId == 3) {
        MyInvestCommitReturnViewController *myInvestCommitReturnVC = [MyInvestCommitReturnViewController new];
        myInvestCommitReturnVC.projectId = supporyedProject.crowdFundId;
        myInvestCommitReturnVC.stateId = supporyedProject.statusId;
        [self.navigationController pushViewController:myInvestCommitReturnVC animated:YES];
    }else if (supporyedProject.statusId == 4 || supporyedProject.statusId == 5 || supporyedProject.statusId == 6){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = sender.tag;
        [alert show];
    }
}

//    UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SupportedProject *supporyedProject = _myInvestList[alertView.tag];
    [MBProgressHUD showStatus:nil toView:self.view];
    if (buttonIndex == 1) {
        [self.httpUtil requestDic4MethodName:@"User/DeleteCf" parameters:@{@"CrowdFundId":@(supporyedProject.crowdFundId)} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [MBProgressHUD dismissHUDForView:self.view];
                [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                [_myInvestList removeObjectAtIndex:alertView.tag];
                [_myInvestTableView reloadData];
            }else{
                [MBProgressHUD dismissHUDForView:self.view];
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }
}


//   支持详情
- (void)supportDetailsBtnClick:(UIButton *)sender
{
    SupportedProject *supporyedProject = _myInvestList[sender.tag];
    SupportDetailsViewController *supportDetailsVC = [SupportDetailsViewController new];
    supportDetailsVC.projectId = supporyedProject.crowdFundId;
    supportDetailsVC.stateId = supporyedProject.statusId;
    [self.navigationController pushViewController:supportDetailsVC animated:YES];
}

#pragma mark - Actions
- (void)myIconBtnClick:(UIButton *)sender
{
    FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc]init];
    SupportedProject *projects = _myInvestList[sender.tag];
    friendDetailsVC.username = projects.userName;
    [self.navigationController pushViewController:friendDetailsVC animated:YES];
}
@end
