//
//  MyStartSupportCountViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartSupportCountViewController.h"
#import "SupportPeopleTableViewCell.h"
#import "FriendDetailViewController.h"

@interface MyStartSupportCountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myStartSupportCountTableView;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *myStartSupportArr;
@property (nonatomic,strong)NSString *timestampStr;
@end

@implementation MyStartSupportCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支持次数";
    _pageIndex = 1;
    _timestampStr = @"";
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getSupportCountData];
}

- (void)setTableViewInfo
{
    [_myStartSupportCountTableView registerNib:[UINib nibWithNibName:@"SupportPeopleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SupportPeopleTableViewCell"];
    [self setupRefreshWithTableView:_myStartSupportCountTableView];
    _myStartSupportCountTableView.tableFooterView = [UIView new];
}

- (void)getSupportCountData{
    [self.httpUtil requestDic4MethodName:@"User/SupportedMan" parameters:@{@"PageIndex":@(_pageIndex),@"RepayId":@(_repayId),@"Timestamp":_timestampStr,@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [_myStartSupportCountTableView.mj_header endRefreshing];
            [_myStartSupportCountTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myStartSupportArr removeAllObjects];
            }
            [MBProgressHUD dismissHUDForView:self.view];
            
            _timestampStr = [[dic objectForKey:@"List"] objectForKey:@"Timestamp"];
            NSArray *arr = [[dic objectForKey:@"List"] objectForKey:@"DataSet"];
            [self.myStartSupportArr addObjectsFromArray:arr];
            
            if ([[[dic objectForKey:@"List"] valueForKey:@"PageCount"] integerValue] == [[[dic objectForKey:@"List"] valueForKey:@"PageIndex"] integerValue])
            {
                [_myStartSupportCountTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myStartSupportCountTableView reloadData];
            
            if (_myStartSupportArr.count == 0) {
                self.hideNoMsg = NO;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myStartSupportArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SupportPeopleTableViewCell";
    SupportPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SupportPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.supportCountDic = _myStartSupportArr[indexPath.row];
    cell.supportIconBtn.tag = indexPath.row;
    [cell.supportIconBtn addTarget:self action:@selector(supportIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)supportIconBtnClick:(UIButton *)sender
{
    NSDictionary *dic = _myStartSupportArr[sender.tag];
    FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
    friendDetailsVC.username = [dic objectForKey:@"UserName"];
    [self.navigationController pushViewController:friendDetailsVC animated:YES];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    _timestampStr = @"";
    [self getSupportCountData];
}

- (void)footerRefreshloadData
{
    if (_myStartSupportCountTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self getSupportCountData];
    }
}

- (NSMutableArray *)myStartSupportArr
{
    if (!_myStartSupportArr) {
        _myStartSupportArr = [NSMutableArray array];
    }
    return _myStartSupportArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
