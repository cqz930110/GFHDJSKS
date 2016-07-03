//
//  RaiseFundsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "RaiseFundsViewController.h"
#import "RaiseFundsTableViewCell.h"
#import "User.h"
#import "LoginViewController.h"
#import "FriendDetailViewController.h"
#import "BaseNavigationController.h"
#import "MoreReturnContentViewController.h"

@interface RaiseFundsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *raiseFundsTableView;
@property (nonatomic,strong)NSMutableArray *raiseFundsArr;
@property (nonatomic,assign)int pageIndex;
@property (nonatomic,strong)NSString *timestampStr;
@end

@implementation RaiseFundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筹款动态";
    [self backBarItem];
    _pageIndex = 1;
    _timestampStr = @"";
    [self setTableViewInfo];
    
    [self headerRefreshloadData];
}

- (void)setTableViewInfo
{
    _raiseFundsTableView.tableFooterView = [UIView new];
    [_raiseFundsTableView registerNib:[UINib nibWithNibName:@"RaiseFundsTableViewCell" bundle:nil] forCellReuseIdentifier:@"RaiseFundsTableViewCell"];
}

- (void)getRaiseFundsDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"CrowdFund/FundDynamic" parameters:@{@"CrowdFundId":@(_projectId),@"PageIndex":@(_pageIndex),@"PageSize":@(10),@"Timestamp":_timestampStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (_pageIndex == 1) {
                [_raiseFundsArr removeAllObjects];
            }
            [_raiseFundsTableView.mj_header endRefreshing];
            [_raiseFundsTableView.mj_footer endRefreshing];
            [MBProgressHUD dismissHUDForView:self.view];
            NSArray *arr = [[dic objectForKey:@"DynamicList"] objectForKey:@"DataSet"];
            [self.raiseFundsArr addObjectsFromArray:arr];
            _timestampStr = [[dic objectForKey:@"DynamicList"] objectForKey:@"Timestamp"];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        [_raiseFundsTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _raiseFundsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RaiseFundsTableViewCell";
    RaiseFundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RaiseFundsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.raiseFundUserIconBtn addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.raiseFundUserIconBtn.tag = indexPath.row;
    cell.raiseFundDic = _raiseFundsArr[indexPath.row];
    [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreBtn.tag = indexPath.row;
    return cell;
}

- (void)userIconBtnClick:(UIButton *)sender
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
//        Project *projects = _raiseFundsArr[sender.tag];
//        friendDetailsVC.username = projects.userName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }else{
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

//   更多跳转
- (void)moreBtnClick:(UIButton *)sender
{
    MoreReturnContentViewController *moreReturnVC = [MoreReturnContentViewController new];
    NSDictionary *dic = _raiseFundsArr[sender.tag];
    moreReturnVC.returnContentStr = [dic objectForKey:@"Description"];
    [self.navigationController pushViewController:moreReturnVC animated:YES];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getRaiseFundsDate];
    
}

- (void)footerRefreshloadData
{
    if (_raiseFundsTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        [self getRaiseFundsDate];
    }
}

- (NSMutableArray *)raiseFundsArr
{
    if (!_raiseFundsArr) {
        _raiseFundsArr = [NSMutableArray array];
    }
    return _raiseFundsArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
