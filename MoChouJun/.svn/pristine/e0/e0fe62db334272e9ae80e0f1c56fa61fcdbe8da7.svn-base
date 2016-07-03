//
//  SupportDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SupportDetailsViewController.h"
#import "ExpressInfoTableViewCell.h"
#import "NoExpressReturnTableViewCell.h"
#import "NoExpressTableViewCell.h"
#import "ExpressObj.h"
#import "ReflectUtil.h"

@interface SupportDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supportDetailsTableView;
@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,strong)NSMutableArray *supportDetailsArr;
@end

@implementation SupportDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    _pageIndex = 1;
    self.title = @"我的支持";
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getExpressInfoData];
}

- (void)getExpressInfoData
{
    [self.httpUtil requestDic4MethodName:@"User/Support" parameters:@{@"CrowdFundId":@(_projectId),@"TypeId":@(1),@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [_supportDetailsTableView.mj_header endRefreshing];
            [_supportDetailsTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_supportDetailsArr removeAllObjects];
            }
            NSArray *arr = [ReflectUtil reflectDataWithClassName:@"ExpressObj" otherObject:[[dic valueForKey:@"SupportList"] valueForKey:@"DataSet"] isList:YES];
            [self.supportDetailsArr addObjectsFromArray:arr];
            
            if ([[[dic valueForKey:@"SupportList"] valueForKey:@"PageCount"] integerValue] == [[[dic valueForKey:@"SupportList"] valueForKey:@"PageIndex"] integerValue])
            {
                [_supportDetailsTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_supportDetailsTableView reloadData];
            
            if (_supportDetailsArr.count == 0) {
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
    [_supportDetailsTableView registerNib:[UINib nibWithNibName:@"ExpressInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressInfoTableViewCell"];
    [_supportDetailsTableView registerNib:[UINib nibWithNibName:@"NoExpressReturnTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoExpressReturnTableViewCell"];
    [_supportDetailsTableView registerNib:[UINib nibWithNibName:@"NoExpressTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoExpressTableViewCell"];
    _supportDetailsTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_supportDetailsTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _supportDetailsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressObj *express = _supportDetailsArr[indexPath.section];
    if (express.typeId == 1){
        return 172;
    }else if (express.typeId == 2){
        return 105;
    }else if (express.typeId == 3){
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressObj *express = _supportDetailsArr[indexPath.section];
    if (express.typeId == 1) {
        static NSString *cellID = @"ExpressInfoTableViewCell";
        ExpressInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[ExpressInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = @"support";
        cell.expressObj = express;
        return cell;
    }else if (express.typeId == 2){
        static NSString *cellID = @"NoExpressTableViewCell";
        NoExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[NoExpressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.express = express;
        return cell;
    }else if (express.typeId == 3){
        static NSString *cellID = @"NoExpressReturnTableViewCell";
        NoExpressReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[NoExpressReturnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.express = express;
        return cell;
    }
    return nil;
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getExpressInfoData];
}

- (void)footerRefreshloadData
{
    if (_supportDetailsTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self getExpressInfoData];
    }
}

- (NSMutableArray *)supportDetailsArr
{
    if (!_supportDetailsArr) {
        _supportDetailsArr = [NSMutableArray array];
    }
    return _supportDetailsArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
