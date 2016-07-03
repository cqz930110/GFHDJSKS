//
//  AdDetailViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/19.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AdDetailViewController.h"

@interface AdDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"陌筹君";
    [self backBarItem];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adDetailUrl]]];
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

@end
