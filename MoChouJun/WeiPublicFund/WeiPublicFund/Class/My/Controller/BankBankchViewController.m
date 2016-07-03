//
//  BankBankchViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/2/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BankBankchViewController.h"
#import "BankBankch.h"

@interface BankBankchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *bankBankchs;
@end

@implementation BankBankchViewController

- (void)viewDidLoad {
    [self backBarItem];
    self.title  = @"支行选择";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestBankchList];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankBankchs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    BankBankch *bankch = _bankBankchs[indexPath.row];
    cell.textLabel.text = bankch.branchName;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate optionBankBranck:_bankBankchs[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestBankchList
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Bank/Branch" parameters:@{@"BankTypeId":@(_bankTypeId),@"DistrictId":@(_districtId)} result:^(NSArray *arr, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            _bankBankchs = arr;
            
            if (_bankBankchs.count)
            {
                self.hideNoMsg = YES;
                [_tableView reloadData];
            }
            else
            {
                self.hideNoMsg = NO;
            }
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"BankBankch" key:nil];
}

@end
