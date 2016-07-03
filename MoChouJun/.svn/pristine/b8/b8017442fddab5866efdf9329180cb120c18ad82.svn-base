//
//  SeeProjectDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/8.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SeeProjectDetailsViewController.h"
#import "NSString+Adding.h"

@interface SeeProjectDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *seeContentLab;

@end

@implementation SeeProjectDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看项目详情";
    [self backBarItem];
    
    [self setupLableInfo];
    
}

- (void)setupLableInfo
{
    _seeContentLab.height =  [_contentStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, SCREEN_HEIGHT)].height;
    _seeContentLab.text = _contentStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
