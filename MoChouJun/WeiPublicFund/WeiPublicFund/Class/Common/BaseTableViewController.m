//
//  BaseTableViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/29.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MobClick.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super  viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
