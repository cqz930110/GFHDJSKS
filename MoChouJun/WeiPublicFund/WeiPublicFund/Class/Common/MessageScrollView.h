//
//  MessageScrollView.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/12/7.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,weak,readonly) NSTimer *moveTime; //循环滚动的周期时间
@property (strong,nonatomic) NSArray * messages;
- (instancetype)initWithFrame:(CGRect)frame withMessages:(NSArray *)messages;
@end
