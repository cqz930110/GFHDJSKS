//
//  MoreReturnContentViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/5/30.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MoreReturnContentViewController.h"
#import "NSString+Adding.h"

@interface MoreReturnContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *returnContentLab;

@end

@implementation MoreReturnContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"回报介绍";
    
    [self setupLableInfo];
}

- (void)setupLableInfo
{
    _returnContentLab.height =  [_returnContentStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, SCREEN_HEIGHT)].height;
    _returnContentLab.text = _returnContentStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
