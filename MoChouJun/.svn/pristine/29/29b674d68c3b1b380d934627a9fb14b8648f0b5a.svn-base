//
//  ProtocolViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/1/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSURL *url;
@end

@implementation ProtocolViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    self.view.backgroundColor = [UIColor whiteColor];
    [self backBarItem];
    
    [self getUrlData];
}

- (void)getUrlData
{
    [self.httpUtil requestDic4MethodName:@"Personal/Links" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
//            NSLog(@"--====%@",dic);
            NSString *urlStr = [dic objectForKey:@"UserAgreement"];
            _url = [NSURL URLWithString:urlStr];
            [self setWebViewInfo];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)setWebViewInfo
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    _webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [_webView setUserInteractionEnabled:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];

    NSURLRequest *request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
