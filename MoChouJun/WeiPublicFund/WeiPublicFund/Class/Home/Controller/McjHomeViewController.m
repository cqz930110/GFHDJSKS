//
//  McjHomeViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/2.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "McjHomeViewController.h"
#import "AdScrollView.h"
#import "PageScrollTableViewsController.h"
#import "NetWorkingUtil.h"


@interface McjHomeViewController ()

@property (nonatomic,strong)NSMutableArray *titleMutableArr;
@property (nonatomic,strong)NSMutableArray *tagIdArr;

@end

@implementation McjHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHomeBannarDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)getHomeBannarDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"Home/Banner" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        
        NSLog(@"99999-----%@",dic);
        if (status == 1 || status == 2) {
            NSArray *arr = [dic objectForKey:@"TagList"];
            NSMutableArray *bannarImageArr = [dic objectForKey:@"Banners"];
            for (NSDictionary *tagDic in arr) {
                [self.titleMutableArr addObject:[tagDic objectForKey:@"Name"]];
                [self.tagIdArr addObject:[tagDic objectForKey:@"Id"]];
            }
            if (_titleMutableArr) {
                [MBProgressHUD dismissHUDForView:self.view];
                PageScrollTableViewsController * pageController = [[PageScrollTableViewsController alloc]initWithTitleArray:_titleMutableArr Image:bannarImageArr tagId:_tagIdArr];
                pageController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
                [self.view addSubview:pageController.view];
                [self addChildViewController:pageController];
            }
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (NSMutableArray *)titleMutableArr
{
    if (!_titleMutableArr) {
        _titleMutableArr = [NSMutableArray array];
    }
    return _titleMutableArr;
}

- (NSMutableArray *)tagIdArr
{
    if (!_tagIdArr) {
        _tagIdArr = [NSMutableArray array];
    }
    return _tagIdArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
