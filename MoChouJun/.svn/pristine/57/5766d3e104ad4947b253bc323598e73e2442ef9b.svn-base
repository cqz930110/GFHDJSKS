//
//  ExpressInfoViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ExpressInfoViewController.h"
#import "ExpressInfoTableViewCell.h"
#import "ExpressObj.h"
#import "ReflectUtil.h"

@interface ExpressInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *expressInfoTableView;
@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,strong)NSMutableArray *expressInfoArr;
@property (nonatomic,strong)UIWebView *phoneWebView;
@end

@implementation ExpressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    _pageIndex = 1;
    self.title = @"快递信息";
    
    [self setupBarButtomItemWithTitle:@"在线客服" target:self action:@selector(kefuBtnClick) leftOrRight:NO];
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getExpressInfoData];
}

- (void)kefuBtnClick
{
    _phoneWebView = [[UIWebView alloc] init];
    NSString*string = [NSString stringWithFormat:@"%@",@"400-0097882"];
    NSString *telStr = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
    [_phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:_phoneWebView];
}

- (void)getExpressInfoData
{
    [self.httpUtil requestDic4MethodName:@"User/Support" parameters:@{@"CrowdFundId":@(_projectId),@"TypeId":@(2),@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [_expressInfoTableView.mj_header endRefreshing];
            [_expressInfoTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_expressInfoArr removeAllObjects];
            }
            NSArray *arr = [ReflectUtil reflectDataWithClassName:@"ExpressObj" otherObject:[[dic valueForKey:@"SupportList"] valueForKey:@"DataSet"] isList:YES];
            [self.expressInfoArr addObjectsFromArray:arr];
            
            if ([[[dic valueForKey:@"SupportList"] valueForKey:@"PageCount"] integerValue] == [[[dic valueForKey:@"SupportList"] valueForKey:@"PageIndex"] integerValue])
            {
                [_expressInfoTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_expressInfoTableView reloadData];
            
            if (_expressInfoArr.count == 0) {
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
    [_expressInfoTableView registerNib:[UINib nibWithNibName:@"ExpressInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressInfoTableViewCell"];
    _expressInfoTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_expressInfoTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _expressInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
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
    static NSString *cellID = @"ExpressInfoTableViewCell";
    ExpressInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ExpressInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ExpressObj *express = _expressInfoArr[indexPath.section];
    cell.expressObj = express;
    cell.expressCommitBtn.tag = indexPath.section;
    [cell.expressCommitBtn addTarget:self action:@selector(expressCommitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)expressCommitBtnClick:(UIButton *)sender
{
    ExpressObj *express = _expressInfoArr[sender.tag];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/Update" parameters:@{@"StatusId":@(_stateId),@"SupportProjectId":@(express.supportProjectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showSuccess:msg toView:self.view];
            [sender setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"]];
            sender.userInteractionEnabled = NO;
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getExpressInfoData];
}

- (void)footerRefreshloadData
{
    if (_expressInfoTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self getExpressInfoData];
    }
}

- (NSMutableArray *)expressInfoArr
{
    if (!_expressInfoArr) {
        _expressInfoArr = [NSMutableArray array];
    }
    return _expressInfoArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
