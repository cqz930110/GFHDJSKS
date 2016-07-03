//
//  WithdrawOptionView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/30.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "WithdrawOptionView.h"
#import "WithdrawCell.h"
#import "WithdrawAccount.h"
@interface WithdrawOptionView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *noMessageView;
@end
@implementation WithdrawOptionView
- (void)awakeFromNib
{
    [self setupTableView];
}

- (void)setupTableView
{
    [_tableView registerNib:[UINib nibWithNibName:@"WithdrawCell" bundle:nil] forCellReuseIdentifier:@"withdrawCell"];
    _tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (_withdrawType == WithdrawTypeNone)
    {
        count = 0;
    }
    else
    {
        NSInteger index = _withdrawType - 1;
        NSArray *dataSource = _withdrawTypeDataSource[index];
        count = dataSource.count;
    }
    if (count == 0)
    {
        _noMessageView.hidden = NO;
    }
    else
    {
        _noMessageView.hidden = YES;

    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"withdrawCell" forIndexPath:indexPath];
    NSInteger index = _withdrawType - 1;
    NSArray *dataSource = _withdrawTypeDataSource[index];
    WithdrawAccount *account = dataSource[indexPath.row];
    [cell title:account.realName detail:account.accountNum ];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回账号信息；
    if ([self.delegate respondsToSelector:@selector(withdrawOptionView:optionWithdrawInfomation:)]) {
        self.hidden  = YES;
        NSInteger index = _withdrawType - 1;
        NSArray *dataSource = _withdrawTypeDataSource[index];
        [self.delegate withdrawOptionView:self optionWithdrawInfomation:dataSource[indexPath.row]];
    }
}

#pragma mark - Actions
- (IBAction)hidden:(UIButton *)sender
{
    self.hidden = YES;
}

- (IBAction)addAccountAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(withdrawOptionViewAddAccount:)])
    {
        self.hidden = YES;
        [self.delegate withdrawOptionViewAddAccount:self];
    }
}

- (void)setWithdrawType:(WithdrawType)withdrawType
{
    _withdrawType = withdrawType;
    switch (_withdrawType) {
        case WithdrawTypeNone:
            
            break;
        case WithdrawTypeAlipay:
            _titleLabel.text = @"支付宝";
            break;
            
        case WithdrawTypeBank:
            _titleLabel.text = @"银行卡";
            break;
            
        case WithdrawTypeWeixin:
            _titleLabel.text = @"微信";
            break;
        default:
            break;
    }
}

- (void)setWithdrawTypeDataSource:(NSArray *)withdrawTypeDataSource
{
    _withdrawTypeDataSource = withdrawTypeDataSource;
    NSLog(@"%@",self.tableView);
    [self.tableView reloadData];
}

@end
