//
//  ProvincesViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/28.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ProvincesViewController.h"

#import "Province.h"

@interface ProvincesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *provincesTableView;
@property (nonatomic,strong)NSArray *provinceArr;
@end

@implementation ProvincesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省份";
    [self backBarItem];
    [self getDataInfo];
}

- (void)getDataInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Place/GetAllProvinces" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            _provinceArr = [NSArray arrayWithArray:arr];
            [_provincesTableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"Province" key:@"List"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Province *province = [_provinceArr objectAtIndex:indexPath.row];
    cell.textLabel.text = province.provinceName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Province *province = [_provinceArr objectAtIndex:indexPath.row];
    CitysViewController *cityVC = [[CitysViewController alloc] init];
    cityVC.isOptionCity = _isOptionCity;
    cityVC.provinceId = [NSString stringWithFormat:@"%zd",province.provinceId];
    cityVC.provinceName = province.provinceName;
    [self.addressDic setValue:province forKey:kProvincesKey];
    cityVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:cityVC animated:YES];
}

@end
