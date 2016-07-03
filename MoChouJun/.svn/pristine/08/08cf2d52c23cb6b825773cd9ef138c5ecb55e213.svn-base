//
//  GroupNoticeViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//
#import "GroupNoticeViewController.h"
#import "AddGroupNoticeViewController.h"
#import "GroupNoticeCell.h"
#import "GroupNotice.h"

#define kRefreshNum 10

@interface GroupNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,GroupNoticeCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *notices;
@property (assign, nonatomic) BOOL isRefreshEnd;
@property (assign, nonatomic) int refreshIndex;
@end

@implementation GroupNoticeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"群公告";
    [self setupAllProperty];
    [self setupTableView];
}

- (void)backAction
{
    if ([self.delegate respondsToSelector:@selector(changeGroupNotice:)]) {
        GroupNotice *notice = [self.notices firstObject];
        [self.delegate changeGroupNotice:notice.content];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestGroupNotice];
}

#pragma mark - Refresh
- (void)footerRefreshloadData
{
    self.refershState = RefershStateUp;
    _refreshIndex++;
    if (!_isRefreshEnd)
    {
        [self requestGroupNotice];
    }
}

#pragma mark - Private
- (void)setupAllProperty
{
    _isRefreshEnd = NO;
    _refreshIndex = 1;
    self.refershState = RefershStateDown;
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupNoticeCell" bundle:nil] forCellReuseIdentifier:@"GroupNoticeCell"];
    self.tableView.tableFooterView = [UIView new];
    [self setupFooterRefresh:_tableView];
}

- (void)addGroupNotice
{
    AddGroupNoticeViewController *vc = [[AddGroupNoticeViewController alloc] init];
    vc.groupId = _groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GroupNoticeCellDelegate
- (void)changeGroupNotice:(GroupNotice *)groupNotice
{
    AddGroupNoticeViewController *vc = [[AddGroupNoticeViewController alloc] init];
    vc.groupId = _groupId;
    vc.notice = groupNotice;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupNoticeCell"];
    cell.canEdit = self.canEdit;
    cell.groupNotice = [_notices objectAtIndex:indexPath.section];
    if (cell.canEdit)
    {
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNotice *notice = [_notices objectAtIndex:indexPath.section];
    return [GroupNoticeCell contentHeightWithContent:notice.content canEdit:_canEdit];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

#pragma mark - Request
- (void)requestGroupNotice
{
    [self.httpUtil requestArr4MethodName:@"GroupNote/List" parameters:@{@"GroupId":_groupId,@"PageIndex":@(_refreshIndex),@"PageSize":@(kRefreshNum)} result:^(NSArray *arr, int status, NSString *msg) {
        [_tableView.mj_footer endRefreshing];
        self.isRefreshEnd = arr.count<kRefreshNum;
        
        if (status == 1)
        {
            if (self.refershState == RefershStateDown)
            {
                [_notices removeAllObjects];
            }
            [self.notices addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
        if (_notices.count == 0)
        {
            self.hideNoMsg = NO;
        }
        else
        {
            self.hideNoMsg = YES;
        }
        
        if (_canEdit && _notices.count == 0)
        {
            if (!self.hideNoMsg  && self.view.tag == 0)
            {
                self.view.tag = 1;
                AddGroupNoticeViewController *vc = [[AddGroupNoticeViewController alloc] init];
                vc.groupId = _groupId;
                [self.navigationController pushViewController:vc animated:NO];
            }
        }
        
    } convertClassName:@"GroupNotice" key:@"DataSet"];
}


#pragma mark - Setter & Getter
- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit =  canEdit;
    if (canEdit)
    {
        [self setupBarButtomItemWithImageName:@"group_notice" highLightImageName:nil selectedImageName:nil target:self action:@selector(addGroupNotice) leftOrRight:NO];
    }
}

- (NSMutableArray *)notices
{
    if (!_notices)
    {
        _notices = [NSMutableArray array];
    }
    return _notices;
}

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

@end
