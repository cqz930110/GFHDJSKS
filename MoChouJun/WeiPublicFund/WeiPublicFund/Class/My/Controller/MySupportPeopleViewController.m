//
//  StartNoReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/30.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MySupportPeopleViewController.h"
#import "SupportMyProjectTableViewCell.h"
#import "FriendDetailViewController.h"
#import "MyInvestDetailsViewController.h"
#import "SupportedProject.h"
#import "ReflectUtil.h"
#import "User.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

@interface MySupportPeopleViewController ()<UITableViewDataSource,UITableViewDelegate,SupportMyProjectTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *startNoProhectTableView;
@end
static NSString *cellIdentifer = @"SupportMyProjectTableViewCell";
@implementation MySupportPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支持的人";
    [self backBarItem];
    [self setTableViewInfo];
}

- (void)setTableViewInfo
{
    _startNoProhectTableView.tableFooterView = [UIView new];
    [_startNoProhectTableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
}

- (void)setCrowdFundId:(int)crowdFundId
{
    _crowdFundId = crowdFundId;
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getSupportPropleDataInfo];
}

#pragma mark - Request
- (void)getSupportPropleDataInfo
{
    [self.httpUtil requestArr4MethodName:@"Repay/SupList" parameters:@{@"CrowdFundId":@(_crowdFundId)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            if (arr.count == 0)
            {
                self.hideNoMsg = NO;
                self.noMsgView.showMsgLab.text = @"又跑哪里玩去了，等阿么找找/(ㄒoㄒ)/~~";
            }
            else
            {
                self.hideNoMsg = YES;
                NSDictionary *dict = arr[0];
                _startNoProjectArr = [ReflectUtil reflectDataWithClassName:@"SupportedProject" otherObject:[dict objectForKey:@"List"] isList:YES];;
                [_startNoProhectTableView reloadData];
            }
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:nil key:nil];
}

#pragma mark - SupportMyProjectTableViewCellDelegate
- (void)supportProjectCellDidClikeIcon:(SupportMyProjectTableViewCell *)cell
{
    if (![User isLogin])
    {
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
    NSIndexPath* indexPath = [_startNoProhectTableView indexPathForCell:cell];
    FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
    SupportedProject *supportedProject = _startNoProjectArr[indexPath.row];
    friendDetailVC.username = supportedProject.userName;
    [self.navigationController pushViewController:friendDetailVC animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _startNoProjectArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupportMyProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.supportMyProject = _startNoProjectArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInvestDetailsViewController *myInvestDetailsVC = [[MyInvestDetailsViewController alloc] init];
    myInvestDetailsVC.supportProject = _startNoProjectArr[indexPath.row];
    myInvestDetailsVC.fromStartProject = @"Cancel";
    [self.navigationController pushViewController:myInvestDetailsVC animated:YES];
}

@end
