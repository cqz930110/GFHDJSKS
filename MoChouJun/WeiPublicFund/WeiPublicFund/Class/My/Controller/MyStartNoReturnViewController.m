//
//  MyStartNoReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/23.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyStartNoReturnViewController.h"
#import "MyStartNoReturnExpressTableViewCell.h"
#import "ChatViewController.h"
#import "BaseNavigationController.h"

@interface MyStartNoReturnViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myStartTotalLab;
@property (weak, nonatomic) IBOutlet UITableView *myStartNoReturnTableView;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSMutableArray *myStartNoReturnArr;
@end

@implementation MyStartNoReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    self.title = _titleStr;
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    
    [self myDraftDateInfo];
}

- (void)setTableViewInfo
{
    [_myStartNoReturnTableView registerNib:[UINib nibWithNibName:@"MyStartNoReturnExpressTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyStartNoReturnExpressTableViewCell"];
    [self setupRefreshWithTableView:_myStartNoReturnTableView];
    _myStartNoReturnTableView.tableFooterView = [UIView new];
}

- (void)myDraftDateInfo
{
    [self.httpUtil requestDic4MethodName:@"User/Unexpress" parameters:@{@"PageIndex":@(_pageIndex),@"RepayId":@(_repayId),@"TypeId":@(_typeId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [_myStartNoReturnTableView.mj_header endRefreshing];
            [_myStartNoReturnTableView.mj_footer endRefreshing];
            if (_pageIndex == 1) {
                [_myStartNoReturnArr removeAllObjects];
            }
            [MBProgressHUD dismissHUDForView:self.view];
            
            NSDictionary *totalDic = [[dic objectForKey:@"List"] objectForKey:@"RepayCount"];
            _myStartTotalLab.text = [NSString stringWithFormat:@"共%@人需要回报，已回报%@人",[totalDic objectForKey:@"AllRepayCount"],[totalDic objectForKey:@"RepayedCount"]];
            
            NSArray *arr = [[dic objectForKey:@"List"] objectForKey:@"DataSet"];
            [self.myStartNoReturnArr addObjectsFromArray:arr];
            
            if ([[[dic objectForKey:@"List"] valueForKey:@"PageCount"] integerValue] == [[[dic objectForKey:@"List"] valueForKey:@"PageIndex"] integerValue])
            {
                [_myStartNoReturnTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myStartNoReturnTableView reloadData];
            
            if (_myStartNoReturnArr.count == 0) {
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
    return _myStartNoReturnArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    static NSString *cellID = @"MyStartNoReturnExpressTableViewCell";
    MyStartNoReturnExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyStartNoReturnExpressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myStartGoReturnDic = _myStartNoReturnArr[indexPath.section];
    cell.myStartSendMsgBtn.tag = indexPath.section;
    [cell.myStartSendMsgBtn addTarget:self action:@selector(myStartSendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.myStartGoReturnBtn.tag = indexPath.section;
    [cell.myStartGoReturnBtn addTarget:self action:@selector(myStartGoReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//   发消息
- (void)myStartSendMsgBtnClick:(UIButton *)sender
{
    NSDictionary *dic = _myStartNoReturnArr[sender.tag];
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

//   去回报
- (void)myStartGoReturnBtnClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否回报该支持人？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = sender.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *dic = _myStartNoReturnArr[alertView.tag];
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"Support/Update" parameters:@{@"StatusId":@(1),@"SupportProjectId":[NSString stringWithFormat:@"%@",[dic objectForKey:@"SupportProjectId"]]} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [MBProgressHUD dismissHUDForView:self.view];
                _pageIndex = 1;
                [self myDraftDateInfo];
            }else{
                [MBProgressHUD dismissHUDForView:self.view];
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self myDraftDateInfo];
}

- (void)footerRefreshloadData
{
    if (_myStartNoReturnTableView.mj_footer.state != MJRefreshStateNoMoreData)
    {
        _pageIndex ++;
        [self myDraftDateInfo];
    }
}

- (NSMutableArray *)myStartNoReturnArr
{
    if (!_myStartNoReturnArr) {
        _myStartNoReturnArr = [NSMutableArray array];
    }
    return _myStartNoReturnArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end