//
//  BaseDataEditViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseDataEditViewController.h"

@interface BaseDataEditViewController ()

@end

@implementation BaseDataEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    [self backBarItem];
    
    [self setupBarButtomItemWithTitle:@"保存 " target:self action:@selector(saveClick) leftOrRight:NO];
    
    
    _baseDataEditTextField.text = _baseDataStr;
}

- (void)saveClick
{
    if (_baseDataEditTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"您还没有填写哦" toView:self.view];
        return;
    }
    NSDictionary *dic = @{@"Info":_baseDataEditTextField.text,
                          @"Type":_titleStr};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BaseDataEdit" object:nil userInfo:dic];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end