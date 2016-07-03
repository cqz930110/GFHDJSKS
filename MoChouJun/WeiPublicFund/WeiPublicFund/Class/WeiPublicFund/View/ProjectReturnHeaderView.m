//
//  ProjectReturnHeaderView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectReturnHeaderView.h"
#import "WeiProjectDetailsViewController.h"
@interface ProjectReturnHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *openStateButton;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@end
@implementation ProjectReturnHeaderView
#pragma mark - Action
- (IBAction)openStateChange
{
    
    _supportReturnManager.isOpen = !_supportReturnManager.isOpen;
    if ([self.delegate respondsToSelector:@selector(projectReturnCellOpenStateChanged:)])
    {
        [self.delegate projectReturnCellOpenStateChanged:self];
    }
}

- (void)setSupportReturnManager:(SupportReturnMamager *)supportReturnManager
{
    _supportReturnManager = supportReturnManager;
    if (_supportReturnManager.isOpen)
    {
        _label1.text = @"收起回报";
        _imageView1.image = [UIImage imageNamed:@"收起"];
    }
    else
    {
        _label1.text = @"展开回报";
        _imageView1.image = [UIImage imageNamed:@"arrow"];
    }
}
@end
