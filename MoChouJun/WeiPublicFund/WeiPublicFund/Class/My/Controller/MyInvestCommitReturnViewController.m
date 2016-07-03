//
//  MyInvestCommitReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyInvestCommitReturnViewController.h"
#import "MySelectReturnTableViewCell.h"
#import "ReflectUtil.h"

@interface MyInvestCommitReturnViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myInvestCommitReturnTableView;
@property (weak, nonatomic) IBOutlet UIButton *commitReturnBtn;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *myInvestArr;

@property (nonatomic,strong)NSMutableArray *selectMyInvestArr;

@property (nonatomic,assign)NSInteger count;
@end

@implementation MyInvestCommitReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择回报";
    _count = 0;
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getMyInvestReturnData];
}
- (void)getMyInvestReturnData
{
    [self.httpUtil requestDic4MethodName:@"User/ConfirmList" parameters:@{@"CrowdFundId":@(_projectId),@"TypeId":@(1),@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [_myInvestCommitReturnTableView.mj_header endRefreshing];
            [_myInvestCommitReturnTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myInvestArr removeAllObjects];
            }
            NSArray *arr = [[dic valueForKey:@"List"] valueForKey:@"DataSet"];
            [self.myInvestArr addObjectsFromArray:arr];
            
            if ([[[dic valueForKey:@"List"] valueForKey:@"PageCount"] integerValue] == [[[dic valueForKey:@"List"] valueForKey:@"PageIndex"] integerValue])
            {
                [_myInvestCommitReturnTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myInvestCommitReturnTableView reloadData];
            
            if (_myInvestArr.count == 0) {
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

- (void)setTableViewInfo
{
    [_myInvestCommitReturnTableView registerNib:[UINib nibWithNibName:@"MySelectReturnTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySelectReturnTableViewCell"];
    _myInvestCommitReturnTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_myInvestCommitReturnTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myInvestArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MySelectReturnTableViewCell";
    MySelectReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MySelectReturnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _myInvestArr[indexPath.row];
    cell.myInvestDic = dic;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySelectReturnTableViewCell *cell = [self.myInvestCommitReturnTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = _myInvestArr[indexPath.row];
    if ([[dic objectForKey:@"StatusId"] integerValue] == 0) {
        [MBProgressHUD showError:@"项目发起人还未开始回报" toView:self.view];
        return;
    }else if ([[dic objectForKey:@"StatusId"] integerValue] == 1){
        [_commitReturnBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3A742"]];
        _commitReturnBtn.userInteractionEnabled = YES;
    }
    if ([self.selectMyInvestArr containsObject:dic]) {
        [self.selectMyInvestArr removeObject:dic];
        cell.myInvestStateImageView.image = [UIImage imageNamed:@"myInvestUnselect"];
    }else if (![self.selectMyInvestArr containsObject:dic]){
        cell.myInvestStateImageView.image = [UIImage imageNamed:@"myInvestSelect"];
        [self.selectMyInvestArr addObject:dic];
    }
    
    if (_selectMyInvestArr.count == 0) {
        [_commitReturnBtn setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"]];
        _commitReturnBtn.userInteractionEnabled = NO;
    }
}
- (IBAction)commitReturnBtnClick:(id)sender {
    if (_selectMyInvestArr.count == 0) {
        [MBProgressHUD showMessag:@"您还没有选择回报" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    NSMutableArray *nameListArr = [NSMutableArray array];
    for (NSDictionary *dic in self.selectMyInvestArr) {
        [nameListArr addObject:[dic objectForKey:@"SupportProjectId"]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:nameListArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *nameListStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self.httpUtil requestDic4MethodName:@"User/ConfirmRepay" parameters:@{@"IdList":nameListStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showSuccess:@"回报成功" toView:self.view];
            _pageIndex = 1;
            [self getMyInvestReturnData];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getMyInvestReturnData];
}

- (void)footerRefreshloadData
{
    if (_myInvestCommitReturnTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self getMyInvestReturnData];
    }
}

- (NSMutableArray *)myInvestArr
{
    if (!_myInvestArr) {
        _myInvestArr = [NSMutableArray array];
    }
    return _myInvestArr;
}

- (NSMutableArray *)selectMyInvestArr
{
    if (!_selectMyInvestArr) {
        _selectMyInvestArr = [NSMutableArray array];
    }
    return _selectMyInvestArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
