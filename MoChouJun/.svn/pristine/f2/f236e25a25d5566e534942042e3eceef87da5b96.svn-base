//
//  CountryViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/11/3.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "DistrictViewController.h"

#import "District.h"

@interface DistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (nonatomic,strong)NSArray *districtArr;
@end

@implementation DistrictViewController


- (void)setCityId:(NSString *)cityId
{
    _cityId = cityId;
    
    //获取区县
    [self getDataInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"区县";
    [self backBarItem];
}

- (void)getDataInfo
{
//    [self.httpUtil requestDic4MethodName:@"Place/GetDistricts" parameters:@{@"CityId":_cityId} result:^(NSDictionary *dic, int status, NSString *msg) {
//        if (status == 1 || status == 2) {
//            NSLog(@"-----%@",dic);
//        }
//        
//    }];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Place/GetDistricts" parameters:@{@"CityId":_cityId} result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            
            _districtArr = [NSArray arrayWithArray:arr];
            [_countryTableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"District" key:@"List"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _districtArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    District *district = [_districtArr objectAtIndex:indexPath.row];
    cell.textLabel.text = district.districtName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    District *district = [_districtArr objectAtIndex:indexPath.row];
    [self.addressDic setValue:district forKey:kDistrictKey];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
}

@end
