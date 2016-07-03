//
//  MyCollectViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectTableViewCell.h"
#import "WeiProjectDetailsViewController.h"

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myCollectTableView;

@property (nonatomic,strong)NSMutableArray *myCollectArr;
@property (nonatomic,assign)NSInteger pageIndex;
@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    [self backBarItem];
    self.title = @"我收藏的项目";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAF1"];
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    
    [self getMyCollectData];
}

- (void)getMyCollectData
{
    [self.httpUtil requestDic4MethodName:@"Favorite/List" parameters:@{@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [_myCollectTableView.mj_header endRefreshing];
            [_myCollectTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myCollectArr removeAllObjects];
            }
            NSArray *arr = [dic objectForKey:@"DataSet"];
            [self.myCollectArr addObjectsFromArray:arr];
            if ([[dic valueForKey:@"PageCount"] integerValue] == [[dic valueForKey:@"PageIndex"] integerValue])
            {
                [_myCollectTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myCollectTableView reloadData];
            
            if (_myCollectArr.count == 0) {
                self.hideNoMsg = NO;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)setTableViewInfo
{
    [_myCollectTableView registerNib:[UINib nibWithNibName:@"MyCollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCollectTableViewCell"];
    [self setupRefreshWithTableView:_myCollectTableView];
    _myCollectTableView.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myCollectArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    static NSString *cellID = @"MyCollectTableViewCell";
    MyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myCollectDic = _myCollectArr[indexPath.section];
    cell.myCollectCancelBtn.tag = indexPath.section;
    [cell.myCollectCancelBtn addTarget:self action:@selector(myCollectCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _myCollectArr[indexPath.section];
    WeiProjectDetailsViewController *weiProjectDetailsVC = [WeiProjectDetailsViewController new];
    weiProjectDetailsVC.projectId = [[dic objectForKey:@"CrowdFundId"] intValue];
    [self.navigationController pushViewController:weiProjectDetailsVC animated:YES];
}

//  取消收藏
- (void)myCollectCancelBtnClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要取消收藏吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = sender.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *dic = _myCollectArr[alertView.tag];
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Favorite/Delete" parameters:@{@"CrowdFundId":@([[dic objectForKey:@"CrowdFundId"] intValue])} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [MBProgressHUD dismissHUDForView:self.view];
                [MBProgressHUD showMessag:@"取消成功" toView:self.view];
                [_myCollectArr removeObjectAtIndex:alertView.tag];
                [_myCollectTableView reloadData];
            }else{
                [MBProgressHUD dismissHUDForView:self.view];
                [MBProgressHUD showMessag:msg toView:self.view];
            }
        }];
    }
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getMyCollectData];
}

- (void)footerRefreshloadData
{
    if (_myCollectTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self getMyCollectData];
    }
}

- (NSMutableArray *)myCollectArr
{
    if (!_myCollectArr) {
        _myCollectArr = [NSMutableArray array];
    }
    return _myCollectArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
