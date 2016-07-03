//
//  WelcomeViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/19.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "TabBarController.h"
#import "User.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *welcomeScrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UIImageView *showImageView;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    float height = SCREEN_HEIGHT;

    _welcomeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _welcomeScrollView.backgroundColor = [UIColor colorWithHexString:@"#ffec47"];
    _welcomeScrollView.pagingEnabled = YES;
    _welcomeScrollView.delegate = self;
    _welcomeScrollView.showsHorizontalScrollIndicator = NO;
    _welcomeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT);
    [self.view addSubview:_welcomeScrollView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH) / 2 - 10, SCREEN_HEIGHT - 35, 20, 25)];
     _pageControl.centerX = self.view.centerX;
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    
    NSInteger count = 5;
    for (int i = 0; i<count; i++)
    {
        CGFloat x = SCREEN_WIDTH * i;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];//[NSString stringWithFormat:@"%d",i]
        [_welcomeScrollView addSubview:imageView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = SCREEN_WIDTH * 4 + 50;
    CGFloat y = SCREEN_HEIGHT - 150;
    button.frame = CGRectMake(x , y , SCREEN_WIDTH - 100, 150);
    [button addTarget:self action:@selector(gotoTabbar) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];
    [_welcomeScrollView addSubview:button];
}

- (void)gotoTabbar
{
    BaseNavigationController *navigationController;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.mainController == nil) {
        appDelegate.mainController = [[TabBarController alloc] init];
        navigationController = [[BaseNavigationController alloc] initWithRootViewController:appDelegate.mainController];
    }else{
        navigationController  = (BaseNavigationController *)appDelegate.mainController.navigationController;
    }
    [User saveLogin];
    appDelegate.window.rootViewController = navigationController;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = _welcomeScrollView.contentOffset.x / SCREEN_WIDTH;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
