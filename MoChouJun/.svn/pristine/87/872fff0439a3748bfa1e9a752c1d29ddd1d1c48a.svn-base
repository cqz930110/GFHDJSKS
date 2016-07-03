//
//  JDpayViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "JDpayViewController.h"
#import <AFURLRequestSerialization.h>
#import "User.h"
#import "JPUSHService.h"
@interface JDpayViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *supportProjectId;
@end

@implementation JDpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"京东支付";
    [self backBarItem];
    self.webView.backgroundColor = self.view.backgroundColor;
    
    _parmas = [self.httpUtil md5ParameterDicWithDic:_parmas];
    NSString *methodName = [_parmas.allKeys containsObject:@"CrowdFundId"]?@"Support/Add":@"Fund/Recharge";
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[self.httpUtil mainURL] stringByAppendingString:methodName] parameters:_parmas error:nil];
    [self.webView loadRequest:request];
}

- (void)backAction
{
    BOOL canForward = [_webView canGoBack];
    if (canForward)
    {
        [_webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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
    [MBProgressHUD dismissHUDForView:self.view withError:@"请求失败"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 获取 回报id 用于填写地址
    
    if ([_supportProjectId intValue] <= 0 && self.delegate)
    {
        NSArray *arguments = [request.URL.absoluteString  componentsSeparatedByString:@"&"];
        for (NSString *augument in arguments)
        {
            if ([augument rangeOfString:@"SupportProjectId"].location != NSNotFound)
            {
                NSArray *values = [augument componentsSeparatedByString:@"="];
                NSString *supportProjectId = values[1];
                if ([supportProjectId intValue] > 0)
                {
                    _supportProjectId = supportProjectId;
                }
            }
        }
    }
    
    if ([request.URL.absoluteString rangeOfString:@"/Api/JdPay/Success"].location != NSNotFound)
    {
        // 判断是否是支持项目 推送消息
        if ([[_parmas allKeys] containsObject:@"CrowdFundId"])//CrowdFundId
        {
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%@",[_parmas valueForKey:@"CrowdFundId"]];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
            
            if ([self.delegate respondsToSelector:@selector(jdPayFinishedSupportId:)])
            {
                [self.navigationController popViewControllerAnimated:NO];
                [self.delegate jdPayFinishedSupportId:_supportProjectId];
            }
            else
            {
                NSArray *childViewController = self.navigationController.childViewControllers;
                [self.navigationController popToViewController:childViewController[childViewController.count - 3] animated:YES];
//                [self.navigationController popViewControllerAnimated:NO];
            }
            return NO;
        }
        else
        {
            NSArray *childViewControllers = self.navigationController.childViewControllers;
            [self.navigationController popToViewController:[childViewControllers objectAtIndex:1] animated:YES];
        }
    }
    return YES;
}

@end
