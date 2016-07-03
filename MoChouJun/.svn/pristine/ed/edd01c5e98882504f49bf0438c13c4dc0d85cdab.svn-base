//
//  FundBillViewController.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/14.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "FundBillViewController.h"
#import "FundBillCell.h"
@interface FundBillViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableSectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tableDateLab;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *fundBillArr;

@property (nonatomic,assign)NSInteger fundCount;

@end

@implementation FundBillViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hideBottomBar = YES;
    [self setupNavi];
    [self setupTableView];
    _fundCount = 0;
    _pageIndex = 1;
    [self getFundBillDataInfo];
}

- (void)getFundBillDataInfo
{
    [self.httpUtil requestDic4MethodName:@"Fund/List" parameters:@{@"PageIndex":@(_pageIndex),@"PageSize":@(15)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            if(_pageIndex==1)
            {
                [_fundBillArr removeAllObjects];
            }
            NSLog(@"------%@",dic);
            [self.tableView.mj_footer endRefreshing];
            NSArray *arr = [dic objectForKey:@"DataSet"];
            self.fundCount = arr.count;
            
            if (arr.count < 15)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.fundBillArr addObjectsFromArray:arr];
            
            if (_fundBillArr.count == 0)
            {
                self.hideNoMsg = NO;
                self.noMsgView.top = 0;
                self.noMsgView.height = SCREEN_HEIGHT;
                self.noMsgView.width = SCREEN_WIDTH;
            }
            else
            {
                self.hideNoMsg = YES;
                [self.tableView reloadData];
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    }];
}

- (void)setupTableView
{
    self.tableView.tableFooterView = [UIView new];
    [self setupFooterRefresh:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FundBillCell" bundle:nil] forCellReuseIdentifier:@"FundBillCell"];
}

- (void)setupNavi
{
    self.title = @"资金明细";
    [self backBarItem];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fundBillArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundBillCell" forIndexPath:indexPath];
    cell.fundDic = [_fundBillArr objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *dictionary = [_fundBillArr objectAtIndex:section];
    NSString * string = [dictionary objectForKey:@"YearMonth"];
    if (section == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        label.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        label.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = [NSString stringWithFormat:@"     %@",string];
        return label;
    }else if (section > 0) {
        NSDictionary *dic = [_fundBillArr objectAtIndex:section - 1];
        if (![string isEqual:[dic objectForKey:@"YearMonth"]]) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
            label.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            label.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
            label.font = [UIFont systemFontOfSize:13.0f];
            label.text = [NSString stringWithFormat:@"     %@",string];
            return label;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dictionary = [_fundBillArr objectAtIndex:section];
    NSString * string = [dictionary objectForKey:@"YearMonth"];
    if (section > 0) {
        NSDictionary *dic = [_fundBillArr objectAtIndex:section - 1];
        if ([string isEqual:[dic objectForKey:@"YearMonth"]]) {
            return 0.01;
        }
        
    }
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Refresh
- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getFundBillDataInfo];
}

#pragma mark - Getter
- (NSMutableArray *)fundBillArr
{
    if (!_fundBillArr)
    {
        _fundBillArr = [NSMutableArray array];
    }
    return _fundBillArr;
}

@end
