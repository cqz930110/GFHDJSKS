//
//  RegisterBankViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/11/6.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "RegisterBankViewController.h"

@interface RegisterBankViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *registerBankArr;
@end

@implementation RegisterBankViewController

- (void)setBankTypeId:(NSInteger)bankTypeId
{
    _bankTypeId = bankTypeId;
    [self getRegisterBankDataInfo];
}

- (void)setDistrictId:(NSInteger)districtId
{
    _districtId = districtId;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开户行";
    _registerBankArr = [NSMutableArray array];
    [self backBarItem];
    
    
}

- (void)getRegisterBankDataInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Bank/Branch" parameters:@{@"BankTypeId":@(_bankTypeId),@"DistrictId":@(_districtId)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [_registerBankArr addObjectsFromArray:arr];
            NSLog(@"====%@",_registerBankArr);
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        [_registerBankTableView reloadData];
    } convertClassName:nil key:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _registerBankArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [_registerBankArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"BranchName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_registerBankArr objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(registerBank:)])
    {
        [self.delegate registerBank:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
