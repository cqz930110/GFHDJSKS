//
//  EditMyStartProjectViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "EditMyStartProjectViewController.h"
#import "AddProjectDetailsViewController.h"
#import "AddProjectReturnViewController.h"
#import "ChatViewController.h"
#import "BaseNavigationController.h"

@interface EditMyStartProjectViewController ()
@property (nonatomic,strong)UIWebView *phoneWebView;

@property (nonatomic,strong)NSDictionary *myDic;
@end

@implementation EditMyStartProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"编辑项目";
    
    [self getData];
}

- (NSDictionary *)myDic
{
    if (!_myDic) {
        _myDic = [NSDictionary dictionary];
    }
    return _myDic;
}

- (void)getData
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"SysConfig/ServicePhone" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            _myDic = dic;
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}
//  添加项目详情
- (IBAction)addProjectDetailsBtnClick:(id)sender {
    
    AddProjectDetailsViewController *addProjectDetailsVC = [AddProjectDetailsViewController new];
    addProjectDetailsVC.projectId = _projectId;
    addProjectDetailsVC.projectContentStr = _contentStr;
    addProjectDetailsVC.uploadCount = _uploadCount;
    addProjectDetailsVC.editType = @"发起";
    addProjectDetailsVC.repayCount = _repayCount;
    addProjectDetailsVC.titleStr = _titleStr;
    [self.navigationController pushViewController:addProjectDetailsVC animated:YES];
}
//  添加回报
- (IBAction)addReturnBtnClick:(id)sender {
    if (_repayCount == 0) {
        [MBProgressHUD showMessag:@"抱歉您发起的项目是无回报的，不可以再添加" toView:self.view];
    }else{
        AddProjectReturnViewController *addProjectReturnVC = [AddProjectReturnViewController new];
        addProjectReturnVC.addType = @"AddReturn";
        addProjectReturnVC.editType = @"发起";
        addProjectReturnVC.titleStr = _titleStr;
        addProjectReturnVC.crowdFundId = _projectId;
        [self.navigationController pushViewController:addProjectReturnVC animated:YES];
    }
    
}

//  电话联系客服
- (IBAction)phoneConnectBtnClick:(id)sender {
    _phoneWebView = [[UIWebView alloc] init];
    NSString*string = [NSString stringWithFormat:@"%@",[_myDic objectForKey:@"ServicePhone"]];
    NSString *telStr = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
    [_phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:_phoneWebView];
}

//  在线联系客服
- (IBAction)onlineConnectBtnClick:(id)sender {
    
    NSString *nameStr = @"";
    NSArray *arr = [_myDic objectForKey:@"ServiceStaff"];
    if (arr.count > 2) {
        nameStr = arr[1];
    }else{
        nameStr = arr[0];
    }
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:nameStr conversationType:eConversationTypeChat];
    chatController.title = nameStr;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
