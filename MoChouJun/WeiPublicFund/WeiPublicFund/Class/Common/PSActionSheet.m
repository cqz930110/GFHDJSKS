//
//  PSActionSheet.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/18.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "PSActionSheet.h"

@implementation PSActionSheet

//- (instancetype)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
//{
//    if (self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil]) {
//        
//        
//        if (otherButtonTitles) {
//            [self addButtonWithTitle:otherButtonTitles];
//            
//            id buttonTitle = nil;
//            va_list argumentList;
//            va_start(argumentList, otherButtonTitles);
//            
//            while ((buttonTitle=va_arg(argumentList, NSString *))) {
//                [self addButtonWithTitle:buttonTitle];
//            }
//            
//            va_end(argumentList);
//        }
//        
//        if (IS_IOS8_LATE)
//        {
//            UIViewController* vc = [self valueForKey:@"alertController"];
//            vc.view.tintColor = [UIColor blackColor];
//        }
//        else
//        {
//            for (UIView *subview in self.subviews) {
//                
//                if ([subview isKindOfClass:[UIButton class]]) {
//                    UIButton *button = (UIButton *)subview;
//                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                }
//            }
//        }
//    }
//    
//    return self;
//}

- (void)showInView:(UIView *)view
{
    if (IS_IOS8_LATE)
    {
        UIViewController* vc = [self valueForKey:@"alertController"];
        vc.view.tintColor = [UIColor colorWithHexString:@"#0053FA"];
    }
    else
    {
        for (UIView *subview in self.subviews) {
            
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                [button setTitleColor:[UIColor colorWithHexString:@"#0053FA"] forState:UIControlStateNormal];
            }
        }
    }
    [super showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if (IS_IOS8_LATE)
    {
        UIViewController* vc = [self valueForKey:@"alertController"];
        vc.view.tintColor = [UIColor colorWithHexString:@"#0053FA"];
    }
    else
    {
        for (UIView *subview in self.subviews) {
            
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                [button setTitleColor:[UIColor colorWithHexString:@"#0053FA"] forState:UIControlStateNormal];
            }
        }
    }
    [super showFromBarButtonItem:item animated:animated];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
