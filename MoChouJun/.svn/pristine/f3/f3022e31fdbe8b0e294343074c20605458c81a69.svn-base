//
//  MyStartGoReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartGoReturnViewController.h"
#import "MyStartGoReturnTableViewCell.h"
#import "ChatViewController.h"
#import "BaseNavigationController.h"
#import "MyStartSendGoodsViewController.h"

@interface MyStartGoReturnViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myStartGoReturnTotalLab;
@property (weak, nonatomic) IBOutlet UITableView *myStartGoReturnTableView;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *myStartGoReturnArr;

@end

@implementation MyStartGoReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    [self backBarItem];
    self.title = _titleStr;
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    
    [self myDraftDateInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGoodsClick) name:@"SendGoods" object:nil];
}

- (void)sendGoodsClick
{
    _pageIndex = 1;
    [self myDraftDateInfo];
}

- (void)setTableViewInfo
{
    [_myStartGoReturnTableView registerNib:[UINib nibWithNibName:@"MyStartGoReturnTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyStartGoReturnTableViewCell"];
    [self setupRefreshWithTableView:_myStartGoReturnTableView];
    _myStartGoReturnTableView.tableFooterView = [UIView new];
}

- (void)myDraftDateInfo
{
    [self.httpUtil requestDic4MethodName:@"User/Express" parameters:@{@"PageIndex":@(_pageIndex),@"RepayId":@(_repayId),@"TypeId":@(_typeId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [_myStartGoReturnTableView.mj_header endRefreshing];
            [_myStartGoReturnTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myStartGoReturnArr removeAllObjects];
            }
            [MBProgressHUD dismissHUDForView:self.view];
            
            NSDictionary *totalDic = [[dic objectForKey:@"List"] objectForKey:@"RepayCount"];
            _myStartGoReturnTotalLab.text = [NSString stringWithFormat:@"共%@人需要回报，已回报%@人",[totalDic objectForKey:@"AllRepayCount"],[totalDic objectForKey:@"RepayedCount"]];
            
            NSArray *arr = [[dic objectForKey:@"List"] objectForKey:@"DataSet"];
            [self.myStartGoReturnArr addObjectsFromArray:arr];
            
            if ([[[dic objectForKey:@"List"] valueForKey:@"PageCount"] integerValue] == [[[dic objectForKey:@"List"] valueForKey:@"PageIndex"] integerValue])
            {
                [_myStartGoReturnTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myStartGoReturnTableView reloadData];
            
            if (_myStartGoReturnArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 35;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myStartGoReturnArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyStartGoReturnTableViewCell";
    MyStartGoReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyStartGoReturnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myStartGoReturnDic = _myStartGoReturnArr[indexPath.section];
    cell.myStartSendMsgBtn.tag = indexPath.section;
    [cell.myStartSendMsgBtn addTarget:self action:@selector(myStartSendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.myStartGoReturnBtn.tag = indexPath.section;
    [cell.myStartGoReturnBtn addTarget:self action:@selector(myStartGoReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//  发消息
- (void)myStartSendMsgBtnClick:(UIButton *)sender
{
    NSDictionary *dic = _myStartGoReturnArr[sender.tag];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[dic objectForKey:@"UserName"] conversationType:eConversationTypeChat];
    NSString *notesStr = IsStrEmpty([dic objectForKey:@"Notes"])?(IsStrEmpty([dic objectForKey:@"NickName"])?[dic objectForKey:@"UserName"]:[dic objectForKey:@"NickName"]):[dic objectForKey:@"Notes"];
    
    chatController.title = notesStr;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    BOOL isContaintChat = NO;;
    for (UIViewController *viewController in array)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            isContaintChat = YES;
            break;
        }
    }
    
    if (isContaintChat)
    {
        BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
        
        [navi pushViewController:chatController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

//  去回报
- (void)myStartGoReturnBtnClick:(UIButton *)sender
{
    MyStartSendGoodsViewController *myStartSendGoodsVC = [MyStartSendGoodsViewController new];
    myStartSendGoodsVC.sendGoodsDic = _myStartGoReturnArr[sender.tag];
    [self.navigationController pushViewController:myStartSendGoodsVC animated:YES];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self myDraftDateInfo];
}

- (void)footerRefreshloadData
{
    if (_myStartGoReturnTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self myDraftDateInfo];
    }
}

- (NSMutableArray *)myStartGoReturnArr
{
    if (!_myStartGoReturnArr) {
        _myStartGoReturnArr = [NSMutableArray array];
    }
    return _myStartGoReturnArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
