//
//  ProjectMasterplateViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/5/27.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectMasterplateViewController.h"

@interface ProjectMasterplateViewController ()

@end

@implementation ProjectMasterplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目模版";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtomItemWithTitle:@"关闭" target:self action:@selector(closeBtnClick) leftOrRight:NO];
    [self setupBarButtomItemWithTitle:@"" target:self action:nil leftOrRight:YES];
}

- (void)closeBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
