//
//  BaseNavigationController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseNavigationController.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationBar.barTintColor = NaviColor;
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationBar.translucent = NO;
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
//    self.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
//     self.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
