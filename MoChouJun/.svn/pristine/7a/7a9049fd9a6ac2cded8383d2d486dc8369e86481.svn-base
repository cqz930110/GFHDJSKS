//
//  AbountWeViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/14.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "AbountWeViewController.h"

@interface AbountWeViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSURL *url;

@end

@implementation AbountWeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self backBarItem];
    
    [self getUrlData];
}
- (void)getUrlData
{
    [self.httpUtil requestDic4MethodName:@"Personal/Links" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            NSLog(@"--====%@",dic);
            NSString *urlStr = [dic objectForKey:@"AboutUs"];
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
    
    NSLog(@"--====%@",_url);
    NSURLRequest *request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showStatus:nil toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD dismissHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD dismissHUDForView:self.view withError:error.description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
