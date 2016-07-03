//
//  SystemNotificationViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SystemNotificationViewController.h"
#import "SystemNotificationCell.h"
#import "SystemMessage.h"
#define kRefreshNum 15
@interface SystemNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *messages;
@property (assign, nonatomic) BOOL isRefreshEnd;
@property (assign, nonatomic) int refreshIndex;
@end

@implementation SystemNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupAllProperty];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self requestNotification];
}

#pragma mark - Private
- (void)setupAllProperty
{
    _isRefreshEnd = NO;
    _refreshIndex = 1;
}

- (void)setupTableView
{
    self.title = @"消息";
    [self backBarItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemNotificationCell" bundle:nil] forCellReuseIdentifier:@"SystemNotificationCell"];
    self.tableView.tableFooterView = [UIView new];
    [self setupFooterRefresh:_tableView];
}

#pragma mark - Refresh
- (void)footerRefreshloadData
{
    self.refershState = RefershStateUp;
    _refreshIndex++;
    if (!_isRefreshEnd)
    {
        [self requestNotification];
    }
}

#pragma mark - Request
- (void)requestNotification
{
    [self.httpUtil requestArr4MethodName:@"DynaMsg/List" parameters:@{@"PageIndex":@(_refreshIndex),@"PageSize":@(kRefreshNum)} result:^(NSArray *arr, int status, NSString *msg)
    {
        [_tableView.mj_footer endRefreshing];
        self.isRefreshEnd = arr.count<kRefreshNum;
        
        if (status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [self.messages addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if (_messages.count == 0)
        {
            self.hideNoMsg = NO;
        }
        else
        {
            self.hideNoMsg = YES;
        }
    } convertClassName:@"SystemMessage" key:@"DataSet"];
}

#pragma mark - Setter
- (void)setIsRefreshEnd:(BOOL)isRefreshEnd
{
    _isRefreshEnd = isRefreshEnd;
    
    if (_isRefreshEnd)
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
    }
}

- (NSMutableArray *)messages
{
    if (!_messages)
    {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemNotificationCell" forIndexPath:indexPath];
    cell.message = _messages[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMessage *message = _messages[indexPath.row];
    return [SystemNotificationCell contentHeightContentString:message.message];
}

@end
