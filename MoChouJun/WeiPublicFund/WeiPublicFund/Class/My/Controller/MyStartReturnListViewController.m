//
//  MyStartReturnListViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartReturnListViewController.h"
#import "MyStartReturnListTableViewCell.h"
#import "MyStartGoReturnViewController.h"
#import "MyStartNoReturnViewController.h"

@interface MyStartReturnListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myStartReturnListTableView;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *myStartReturnListArr;
@end

@implementation MyStartReturnListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回报列表";
    _pageIndex = 1;
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self myDraftDateInfo];
}

- (void)setTableViewInfo
{
    [_myStartReturnListTableView registerNib:[UINib nibWithNibName:@"MyStartReturnListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyStartReturnListTableViewCell"];
    [self setupRefreshWithTableView:_myStartReturnListTableView];
    _myStartReturnListTableView.tableFooterView = [UIView new];
}

- (void)myDraftDateInfo
{
    [self.httpUtil requestDic4MethodName:@"Repay/AllList" parameters:@{@"PageIndex":@(_pageIndex),@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [_myStartReturnListTableView.mj_header endRefreshing];
            [_myStartReturnListTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myStartReturnListArr removeAllObjects];
            }
            [MBProgressHUD dismissHUDForView:self.view];
            NSArray *arr = [dic objectForKey:@"DataSet"];
            [self.myStartReturnListArr addObjectsFromArray:arr];
            NSLog(@"------%@",_myStartReturnListArr);
            if ([[dic valueForKey:@"PageCount"] integerValue] == [[dic valueForKey:@"PageIndex"] integerValue])
            {
                [_myStartReturnListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myStartReturnListTableView reloadData];
            
            if (_myStartReturnListArr.count == 0) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myStartReturnListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyStartReturnListTableViewCell";
    MyStartReturnListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyStartReturnListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myStartReturnListDic = _myStartReturnListArr[indexPath.section];
    cell.goReturnBtn.tag = indexPath.section;
    [cell.goReturnBtn addTarget:self action:@selector(goReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)goReturnBtnClick:(UIButton *)sender
{
    NSDictionary *dic = _myStartReturnListArr[sender.tag];
    
    if ([[dic objectForKey:@"IsExpressed"] intValue] == 1) {
        MyStartGoReturnViewController *myStartGoReturnVC = [MyStartGoReturnViewController new];
        myStartGoReturnVC.repayId = [[dic objectForKey:@"Id"] intValue];
        if ([[dic objectForKey:@"StatusId"] intValue] == 1) {
            myStartGoReturnVC.typeId = 1;
        }else{
            myStartGoReturnVC.typeId = 2;
        }
        if ([[dic objectForKey:@"Description"] length] <= 9) {
            myStartGoReturnVC.titleStr = [dic objectForKey:@"Description"];
        }else{
            myStartGoReturnVC.titleStr = [[dic objectForKey:@"Description"] substringToIndex:9];
        }
        [self.navigationController pushViewController:myStartGoReturnVC animated:YES];
    }else if ([[dic objectForKey:@"IsExpressed"] intValue] == 0){
        MyStartNoReturnViewController *myStartGoReturnVC = [MyStartNoReturnViewController new];
        myStartGoReturnVC.repayId = [[dic objectForKey:@"Id"] intValue];
        if ([[dic objectForKey:@"StatusId"] intValue] == 1) {
            myStartGoReturnVC.typeId = 1;
        }else{
            myStartGoReturnVC.typeId = 2;
        }
        if ([[dic objectForKey:@"Description"] length] <= 9) {
            myStartGoReturnVC.titleStr = [dic objectForKey:@"Description"];
        }else{
            myStartGoReturnVC.titleStr = [[dic objectForKey:@"Description"] substringToIndex:9];
        }
        [self.navigationController pushViewController:myStartGoReturnVC animated:YES];
    }
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self myDraftDateInfo];
}

- (void)footerRefreshloadData
{
    if (_myStartReturnListTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self myDraftDateInfo];
    }
}

- (NSMutableArray *)myStartReturnListArr
{
    if (!_myStartReturnListArr) {
        _myStartReturnListArr = [NSMutableArray array];
    }
    return _myStartReturnListArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
