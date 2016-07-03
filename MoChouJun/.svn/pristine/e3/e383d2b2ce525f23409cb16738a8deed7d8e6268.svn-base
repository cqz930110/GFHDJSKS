//
//  PageWebViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/30.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "PageWebViewController.h"

@interface PageWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;
//@property (nonatomic,strong)NSURL *url;
@end

@implementation PageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"陌筹君";
    
    NSLog(@"------%@",_urlStr);
    [self setWebViewInfo];
    
}


- (void)setWebViewInfo
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    _webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [_webView setUserInteractionEnabled:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];
    
//    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *htmls = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, _urlStr.length)];
    NSURL *url = [NSURL URLWithString:htmls];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
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
    [MBProgressHUD dismissHUDForView:self.view];
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
