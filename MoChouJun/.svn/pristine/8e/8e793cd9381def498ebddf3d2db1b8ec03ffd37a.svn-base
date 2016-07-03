//
//  OptionAddressViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/11.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "OptionAddressViewController.h"
#import "ExpressAddresseCell.h"
#import "Address.h"
#import "AddExpressAddressViewController.h"

@interface OptionAddressViewController ()<ExpressAddresseCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableArray *addressList;
@property (weak, nonatomic) Address *optionAddress;
@end

@implementation OptionAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestExpressAddressList];
}

- (void)setupTableView
{
    _tableView.tableHeaderView = self.tableHeaderView;
    [_tableView registerNib:[UINib nibWithNibName:@"ExpressAddresseCell" bundle:nil] forCellReuseIdentifier:@"ExpressAddresseCell"];
}

- (void)setupNavi
{
    self.title = @"选择收货地址";
//    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"完成" target:self action:@selector(comfirmAction) leftOrRight:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
}

#pragma mark - Action
- (IBAction)addNewAddress
{
    AddExpressAddressViewController *vc = [[AddExpressAddressViewController alloc] init];
    //    vc.showBackItem = YES;
    vc.type = @"添加";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)comfirmAction
{
    if (_optionAddress.Id == 0)
    {
        [self payComfirmBack];
    }
    
    [MBProgressHUD showStatus:@"正在操作中..." toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Support/UpdateSupportAddress" parameters:@{@"Id":_supportId,@"UserAddressId":@(_optionAddress.Id)} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"回报会很快飞向你~~"];
            [self performSelector:@selector(payComfirmBack) withObject:nil afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view  withError:msg];
        }
    }];
}

- (void)payComfirmBack
{
    NSArray *childViewControllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:[childViewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Setter
- (NSMutableArray *)addressList
{
    if (!_addressList)
    {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}

#pragma mark - Request
- (void)requestExpressAddressList
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Address/Get" parameters:@{@"PageIndex":@1,@"PageSize":@100} result:^(NSArray *arr, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             [MBProgressHUD dismissHUDForView:self.view];
             [self.addressList removeAllObjects];
             [self.addressList addObjectsFromArray:arr];
             [_tableView reloadData];
         }
         else
         {
             [MBProgressHUD dismissHUDForView:self.view withError:msg];
         }
     } convertClassName:@"Address" key:@"DataSet"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressAddresseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressAddresseCell" forIndexPath:indexPath];
    cell.delegate = self;
    Address * address = _addressList[indexPath.row];
    if (address.statusId == 2)
    {
        _optionAddress = address;
    }
    cell.address = address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}



#pragma mark - ExpressAddresseCellDelegate
- (void)expressAddresseCellOptionDefaultAddress:(ExpressAddresseCell *)cell
{
    if (cell.address.statusId == 2)
    {
        return;
    }
    _optionAddress.statusId = 1;
    cell.address.statusId = 2;
    _optionAddress = cell.address;
    [_tableView reloadData];
}
@end
