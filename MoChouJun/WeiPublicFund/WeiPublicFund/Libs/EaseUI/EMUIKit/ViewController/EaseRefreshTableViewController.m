//
//  EaseRefreshTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseRefreshTableViewController.h"

#import <MJRefresh.h>

@interface EaseRefreshTableViewController ()

@property (nonatomic, readonly) UITableViewStyle style;

@end

@implementation EaseRefreshTableViewController

//@synthesize rightItems = _rightItems;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.defaultFooterView;
    [self.view addSubview:_tableView];
//    _page = 0;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    _showTableBlankView = NO;
}

#pragma mark - setter
- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader)
    {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
            header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
            header.stateLabel.font = [UIFont systemFontOfSize:12];
            [header setTitle:@"拉拉阿么就有啦\(^o^)/~" forState:MJRefreshStateIdle];
            [header setTitle:@"刷得好疼，快放开阿么 ::>_<:: " forState:MJRefreshStatePulling];
            [header setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
            self.tableView.mj_header = header;
            [self tableViewDidTriggerHeaderRefresh];
        }
        else
        {
            [self.tableView.mj_header removeFromSuperview];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
             MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
            footer.stateLabel.font = [UIFont systemFontOfSize:12];
            // 设置文字
            [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateIdle];
            [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStatePulling];
            [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"已经没有更多啦" forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer = footer;
        }
        else
        {
            [self.tableView.mj_footer removeFromSuperview];
        }
    }
}

- (void)setShowTableBlankView:(BOOL)showTableBlankView
{
    if (_showTableBlankView != showTableBlankView) {
        _showTableBlankView = showTableBlankView;
    }
}

#pragma mark - getter

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableDictionary *)dataDictionary
{
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    
    return _dataDictionary;
}

- (UIView *)defaultFooterView
{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    
    return _defaultFooterView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCELLDEFAULTHEIGHT;
}

#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}
/**
 *  下拉刷新事件
 */
- (void)tableViewDidTriggerHeaderRefresh
{
    
}

/**
 *  上拉加载事件
 */
- (void)tableViewDidTriggerFooterRefresh
{
    
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak EaseRefreshTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload)
        {
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    });
}

@end
