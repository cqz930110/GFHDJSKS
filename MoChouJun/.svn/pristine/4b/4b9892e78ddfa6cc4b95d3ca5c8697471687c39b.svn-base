//
//  AdViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/28.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    [self requestAdImageUrlComplete:^(NSString *imageUrl) {
//        if (imageUrl.length)
//        {
//            [NetWorkingUtil setImage:_imageView url:imageUrl defaultIconName:nil];
//        }
//    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
     }];
}

@end
