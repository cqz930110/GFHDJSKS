//
//  CitysViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/11/2.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "CitysViewController.h"

#import "City.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic,strong)NSArray *cityArr;
@end

@implementation CitysViewController


- (void)setProvinceId:(NSString *)provinceId
{
    _provinceId = provinceId;
    
    //获取城市
    [self getDataInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"城市";
    [self backBarItem];
}

- (void)getDataInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Place/GetCitys" parameters:@{@"ProvinceId":_provinceId} result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            _cityArr = [NSArray arrayWithArray:arr];
            [_cityTableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"City" key:@"List"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    City *city = [_cityArr objectAtIndex:indexPath.row];
    cell.textLabel.text = city.cityName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *city = [_cityArr objectAtIndex:indexPath.row];

    [self.addressDic setValue:city forKey:kCityKey];
    if (_isOptionCity)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        return;
    }
    DistrictViewController *countryVC = [[DistrictViewController alloc] init];
    countryVC.cityId = [NSString stringWithFormat:@"%d",city.cityId];
    countryVC.cityName = city.cityName;
    countryVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:countryVC animated:YES];
}

@end
