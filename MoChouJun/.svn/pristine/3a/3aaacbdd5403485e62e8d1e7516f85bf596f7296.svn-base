//
//  OptionBankViewController.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/14.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "OptionBankViewController.h"

@interface OptionBankViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *bankTypes;
@end
static NSString *cellIdentifier = @"BankCell";
@implementation OptionBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    [self reaqestJDBankType];
}

- (void)setupTableView
{
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNavi
{
    self.title = @"银行列表";
    [self backBarItem];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = [_bankTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"BankName"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_bankTypes objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(optionBankTypeUserInfo:)])
    {
        [self.delegate optionBankTypeUserInfo:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setter
- (NSMutableArray *)bankTypes
{
    if (!_bankTypes)
    {
        _bankTypes = [NSMutableArray array];
    }
    return _bankTypes;
}

#pragma mark - Request
- (void)reaqestJDBankType
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Bank/JdBankList" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [self.bankTypes addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if (_bankTypes.count)
        {
            self.hideNoMsg = YES;
        }
        else
        {
            self.hideNoMsg = NO;
        }
    } convertClassName:nil key:nil];
}
@end
