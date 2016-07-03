//
//  SeeAllReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/12.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SeeAllReturnViewController.h"
#import "ProjectReturnTableViewCell.h"
#import "MoreReturnContentViewController.h"

@interface SeeAllReturnViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *seeAllReturnTableView;
@property (nonatomic,strong)NSMutableArray *allReturnMutableArr;
@end

@implementation SeeAllReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"全部回报";
    
    [self setupBarButtonInfo];
    
    [self getAllReturnDate];
}

- (void)getAllReturnDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Repay/Get" parameters:@{@"CrowdFundId":@(_crowdFundId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            self.allReturnMutableArr = [dic objectForKey:@"DataSet"];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        [_seeAllReturnTableView reloadData];
    }];
}

- (void)setupBarButtonInfo
{
    [self setupBarButtomItemWithTitle:@"" target:self action:nil leftOrRight:YES];
    [self setupBarButtomItemWithTitle:@"关闭" target:self action:@selector(backBtnClick) leftOrRight:NO];
    [_seeAllReturnTableView registerNib:[UINib nibWithNibName:@"ProjectReturnTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectReturnTableViewCell"];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allReturnMutableArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.00001;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ProjectReturnTableViewCell";
    ProjectReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProjectReturnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.allReturnDic = _allReturnMutableArr[indexPath.section];
    cell.moreBtn.tag = indexPath.section;
    [cell.moreBtn addTarget:self action:@selector(moreContentClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)moreContentClick:(UIButton *)sender
{
    MoreReturnContentViewController *moreReturnContentVC = [MoreReturnContentViewController new];
    moreReturnContentVC.returnContentStr = [[_allReturnMutableArr objectAtIndex:sender.tag] objectForKey:@"Description"];
    [self.navigationController pushViewController:moreReturnContentVC animated:YES];
}

- (NSMutableArray *)allReturnMutableArr
{
    if (!_allReturnMutableArr) {
        _allReturnMutableArr = [NSMutableArray array];
    }
    return _allReturnMutableArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
