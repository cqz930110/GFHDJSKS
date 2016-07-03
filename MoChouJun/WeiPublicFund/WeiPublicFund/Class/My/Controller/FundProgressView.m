//
//  FundProgressView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FundProgressView.h"
@interface FundProgressView()
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@end
@implementation FundProgressView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    _progress = 80;
    UIColor *redColor = [UIColor colorWithHexString:@"#ED462F"];
    UIColor *yellowColor = [UIColor colorWithHexString:@"#F2A24A"];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, rect.size.width, 10);
//    [path moveToPoint:CGPointMake(rect.size.width, 10)];
    CGContextAddEllipseInRect(ctx, CGRectMake(10, 10, rect.size.width - 20, rect.size.width - 20));
    CGContextSetLineWidth(ctx, 20);
    [yellowColor setStroke];
    CGContextStrokePath(ctx);

    if (!_progressLayer)
    {
        _progressLayer = [CAShapeLayer layer];
//        _progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(rect.size.width, 10)];
    CGFloat endAngle = _progress*0.01*M_PI*2 - M_PI_2;
    [path addArcWithCenter:CGPointMake(rect.size.width*0.5, rect.size.width*0.5) radius:(rect.size.width - 20)*0.5 startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor = redColor.CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineWidth = 20;
    
    [self.layer addSublayer:_progressLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.7f;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    //        pathAnimation.delegate = self;
    [pathAnimation setValue:@"progressBarAnimation" forKey:@"animationName"];
    [_progressLayer addAnimation:pathAnimation forKey:nil];
}


@end
