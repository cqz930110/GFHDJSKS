//
//  ProjectProgressView.m
//  画图
//
//  Created by zhoupushan on 15/10/11.
//  Copyright © 2015年 zhoupushan. All rights reserved.
//

#import "ProjectProgressView.h"

#define kTextWidth 40
#define kSpace 10
#define kLineWidth 5
#define kStrFont 12

@interface ProjectProgressView()
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *yellowColor;
@property (nonatomic,strong) UIColor *greenColor;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,assign) NSInteger progress;
@end
@implementation ProjectProgressView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        CGRect rect = frame;
//        rect.size.height = 20;
//        self.frame = rect;
//    }
//    return self;
//}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect rect = self.frame;
//    rect.size.height = 15;
//    self.frame = rect;
//
//}

- (void)awakeFromNib
{
    _isShowProgressText = NO;
    _isLineCapRound = YES;
    _yellowColor = [UIColor colorWithHexString:@"#F2A642"];
    _backColor = BlackDDDDDD;
    _greenColor = GreenColor;
    
}
 
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //start point
    
    CGFloat startLineY = rect.size.height*0.5;
    
    CGFloat startLineX = 4.0;
    
    if (!_isLineCapRound)
    {
        startLineX = 3.5;
    }
    CGFloat lineEndX;
    if (!_isShowProgressText) {
        lineEndX = rect.size.width - kSpace;
    }
    else
    {
        lineEndX = rect.size.width - kTextWidth - kSpace;
    }
    
    CGContextMoveToPoint(ctx, startLineX, startLineY);
    CGContextAddLineToPoint(ctx, lineEndX, startLineY);
    
    CGContextSetLineWidth(ctx, kLineWidth);
//    NSLog(@"%d",self.progressValue);
    if (self.progressValue  == 100)
    {
        if (self.isShowProgressText)
        {
            [_yellowColor setStroke];
        }
        else
        {
            [[UIColor colorWithHexString:@"#F2A642"] setStroke];
        }
    }
    else
    {
        [_backColor setStroke];
    }
    
    if (_isLineCapRound)
    {
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
    }
    else
    {
        CGContextSetLineCap(ctx, kCGLineCapSquare);
    }
    CGContextStrokePath(ctx);
    
    if (self.progressValue != 0 && self.progressValue != 100)
    {
        if (!_animation)
        {
            if (!_progressLayer)
            {
                _progressLayer = [CAShapeLayer layer];
            }
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(startLineX, startLineY)];
            [path addLineToPoint:CGPointMake(startLineX + self.progressValue*0.01*(lineEndX - startLineX), startLineY)];
            
            _progressLayer.path = path.CGPath;
            _progressLayer.strokeColor = _isLineCapRound?_yellowColor.CGColor:[[UIColor colorWithHexString:@"F2A642"] CGColor];
            
            _progressLayer.lineWidth = kLineWidth;
            
            if (_isLineCapRound)
            {
                _progressLayer.lineCap = kCALineCapRound;

            }
            else
            {
                _progressLayer.lineCap = kCALineCapSquare;
            }
            [self.layer addSublayer:_progressLayer];
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5f;
            pathAnimation.fromValue = @(0.0f);
            pathAnimation.toValue = @(1.0f);
            //        pathAnimation.delegate = self;
            [pathAnimation setValue:@"progressBarAnimation" forKey:@"animationName"];
            [_progressLayer addAnimation:pathAnimation forKey:nil];
        }
        else
        {
            CGContextMoveToPoint(ctx, startLineX, startLineY);
            
            CGContextAddLineToPoint(ctx,startLineX + self.progressValue*0.01*(lineEndX - startLineX), startLineY);
            
            UIColor *color = _isLineCapRound?_yellowColor:[UIColor colorWithHexString:@"F2A642"];
            [color setStroke];
//            [_yellowColor setStroke];
            CGContextStrokePath(ctx);
        }

    }
    
    if (_isShowProgressText)
    {
        if (!_textColor)
        {
            _textColor = _yellowColor;
        }
        NSString * progressStr = [NSString stringWithFormat:@"%ld%%",self.progress];
        CGRect strRect = CGRectMake(rect.size.width - kTextWidth, startLineY - kLineWidth-1-2, kTextWidth, rect.size.height);
        
        NSDictionary *sttrbiutes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kStrFont],NSFontAttributeName,_textColor,NSForegroundColorAttributeName, nil];
        [progressStr drawInRect:strRect withAttributes:sttrbiutes];
    }
}

- (void)setProgressValue:(NSInteger)progressValue
{
    [_progressLayer removeFromSuperlayer];
    [_progressLayer removeAllAnimations];

    _progressValue = progressValue;
    
    _progress = _progressValue;
    _progressValue = _progressValue>100?100:_progressValue;
    _progressValue = _progressValue<0?0:_progressValue;
    [self setNeedsDisplay];
    
}

@end
