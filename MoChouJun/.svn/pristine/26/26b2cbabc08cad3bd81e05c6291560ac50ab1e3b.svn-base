//
//  PageTableController.m
//  ScrollViewAndTableView
//
//  Created by fantasy on 16/5/14.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "PageTableController.h"

#import "Common.h"
#import "ProjectTableViewCell.h"
#import "RecommendHomeTableViewCell.h"
#import "NetWorkingUtil.h"
#import "Project.h"
#import "ReflectUtil.h"
#import "User.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "FriendDetailViewController.h"
#import "WeiProjectDetailsViewController.h"
#import <MJRefresh.h>

@interface PageTableController ()

@property (strong, nonatomic) NSArray * titleArray;
@property (nonatomic,strong)NSMutableArray *projectMutableArr;
@property (nonatomic,assign)int index;

@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,strong)NSString *timesTampStr;

@property (nonatomic,assign)NSInteger firstTagId;
@end

@implementation PageTableController

- (instancetype)initWithStyle:(UITableViewStyle)style{
  
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
     self.automaticallyAdjustsScrollViewInsets = NO;
      
      [self.tableView registerNib:[UINib nibWithNibName:@"RecommendHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendHomeTableViewCell"];
      [self.tableView registerNib:[UINib nibWithNibName:@"ProjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectTableViewCell"];
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageIndex = 1;
    _firstTagId = 1;
    _timesTampStr = @"";
    // 上下啦
    [self setupRefreshWithTableView:self.tableView];
    [self getTitleDate];

}

- (void)getTitleDate
{
    [[NetWorkingUtil netWorkingUtil] requestDic4MethodName:@"Home/List" parameters:@{@"PageIndex":@(_pageIndex),@"PageSize":@(10),@"TagId":@(1),@"Timestamp":_timesTampStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if ( status == 1 || status == 2) {
        
            if (_pageIndex == 1) {
                [_projectMutableArr removeAllObjects];
            }
            
            _timesTampStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"CrowdFundList"] objectForKey:@"Timestamp"]];
            
            NSArray *arr = [ReflectUtil reflectDataWithClassName:@"Project" otherObject:[[dic valueForKey:@"CrowdFundList"] valueForKey:@"DataSet"] isList:YES];
            [self.projectMutableArr addObjectsFromArray:arr];
            
            if ([[[dic objectForKey:@"CrowdFundList"] valueForKey:@"PageCount"] integerValue] == [[[dic objectForKey:@"CrowdFundList"] valueForKey:@"PageIndex"] integerValue])
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _projectMutableArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.numOfController == 1) {
        return 215;
    }
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.numOfController == 1) {
        static NSString *cellID = @"RecommendHomeTableViewCell";
        RecommendHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[RecommendHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.project = _projectMutableArr[indexPath.section];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.delegate = self;
        cell.userIconBtn.tag = indexPath.section;
        return cell;
    }else{
        static NSString *cellID = @"ProjectTableViewCell";
        ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[ProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.project = _projectMutableArr[indexPath.section];
        cell.delegate = self;
        cell.userIconBtn.tag = indexPath.section;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiProjectDetailsViewController *projectDetailsVC = [[WeiProjectDetailsViewController alloc]init];
    Project *projects =  _projectMutableArr[indexPath.section];
    projectDetailsVC.projectId = projects.crowdFundId;
    projectDetailsVC.showType = DetailShowTypeReal;
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  if (self.tableViewDidScroll) {
    self.tableViewDidScroll(scrollView.contentOffset.y);
    
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.tableViewDidScroll) {
        self.tableViewWillBeginDragging(scrollView.contentOffset.y);
        
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.tableViewDidScroll) {
        self.tableViewWillBeginDecelerating(scrollView.contentOffset.y);
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.tableViewDidScroll) {
        self.tableViewDidEndDragging(scrollView.contentOffset.y);
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tableViewDidScroll) {
        self.tableViewDidEndDecelerating(scrollView.contentOffset.y);
        
    }
}

- (NSMutableArray *)projectMutableArr
{
    if (!_projectMutableArr) {
        _projectMutableArr = [NSMutableArray array];
    }
    return _projectMutableArr;
}

- (void)updateTableViewIndex:(int)index
{
    _index = index;
    _pageIndex = 1;
    _firstTagId = -1;
    _timesTampStr = @"";
    [self getUpDate];
}

- (void)getUpDate
{
//    [MBProgressHUD showStatus:nil toView:self.view];
    [[NetWorkingUtil netWorkingUtil] requestDic4MethodName:@"Home/List" parameters:@{@"PageIndex":@(_pageIndex),@"PageSize":@(10),@"TagId":@(_index),@"Timestamp":_timesTampStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        [MBProgressHUD dismissHUDForView:self.view];
        if ( status == 1 || status == 2) {
            
            if (_pageIndex == 1) {
                [_projectMutableArr removeAllObjects];
            }
            
            _timesTampStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"CrowdFundList"] objectForKey:@"Timestamp"]];
            NSArray *arr = [ReflectUtil reflectDataWithClassName:@"Project" otherObject:[[dic valueForKey:@"CrowdFundList"] valueForKey:@"DataSet"] isList:YES];
            [self.projectMutableArr addObjectsFromArray:arr];
            
            if (_projectMutableArr.count == 0) {
                [MBProgressHUD dismissHUDForView:self.view];
            }
            
            if ([[[dic objectForKey:@"CrowdFundList"] valueForKey:@"PageCount"] integerValue] == [[[dic objectForKey:@"CrowdFundList"] valueForKey:@"PageIndex"] integerValue])
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)projectTableViewCell:(ProjectTableViewCell *)cell supportProject:(id)project
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
        Project *projects = _projectMutableArr[cell.userIconBtn.tag];
        friendDetailsVC.username = projects.userName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }else{
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

- (void)recommendHomeTableViewCell:(RecommendHomeTableViewCell *)cell supportProject:(id)project
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
        Project *projects = _projectMutableArr[cell.userIconBtn.tag];
        friendDetailsVC.username = projects.userName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }else{
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark - Refresh
- (void)setupHeaderRefresh:(UITableView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshloadData)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"拉拉阿么就有啦\(^o^)/~" forState:MJRefreshStateIdle];
    [header setTitle:@"刷得好疼，快放开阿么 ::>_<:: " forState:MJRefreshStatePulling];
    [header setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
    tableView.mj_header = header;
}

- (void)setupFooterRefresh:(UITableView *)tableView
{
    //    MJRefreshAutoNormalFooter
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshloadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置文字
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateIdle];
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStatePulling];
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经没有更多啦" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = footer;
}

- (void)setupRefreshWithTableView:(UITableView *)tableView
{
    [self setupHeaderRefresh:tableView];
    [self setupFooterRefresh:tableView];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    _timesTampStr = @"";
    if (_firstTagId == 1) {
        [self getTitleDate];
    }else{
        [self getUpDate];
    }
}

- (void)footerRefreshloadData
{
    if (self.tableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        if (_firstTagId == 1) {
            [self getTitleDate];
        }else{
            [self getUpDate];
        }
    }
}

@end
