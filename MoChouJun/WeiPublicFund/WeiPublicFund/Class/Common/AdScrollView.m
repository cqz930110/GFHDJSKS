//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"
#import "HWWeakTimer.h"
#import "NetWorkingUtil.h"
#import "SDWebImageManager.h"
#define UISCREENWIDTH  [UIScreen mainScreen].bounds.size.width//广告的宽度   随时可以改变
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度

#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标

static CGFloat const chageImageTime = 3.0;
static NSUInteger currentImage = 1;//记录中间图片的下标,开始总是为1

@interface AdScrollView ()

{
    //广告的label
    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
   
//    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
    //为每一个图片添加一个广告语(可选)
    UILabel * _leftAdLabel;
    UILabel * _centerAdLabel;
    UILabel * _rightAdLabel;
}

@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@end

@implementation AdScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_centerImageView];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_rightImageView];
    }
    return self;
}

- (void)awakeFromNib
{
    self.bounces = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
    self.delegate = self;
    
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    [self addSubview:_rightImageView];

}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;
    _leftImageView.image = [UIImage imageNamed:_imageNameArray[2]];
    _centerImageView.image = [UIImage imageNamed:_imageNameArray[0]];
    _rightImageView.image = [UIImage imageNamed:_imageNameArray[1]];
}

#pragma mark - LoadImage
- (void)setLoadImage:(NSArray *)loadImage
{
    _loadImage = loadImage;
    if (loadImage.count == 1) {
        [NetWorkingUtil setImage:_centerImageView url:loadImage[0] defaultIconName:nil];
    }else if (loadImage.count == 2)
    {
        [NetWorkingUtil setImage:_leftImageView url:loadImage[1] defaultIconName:nil];
        [NetWorkingUtil setImage:_centerImageView url:loadImage[0] defaultIconName:nil];
        [NetWorkingUtil setImage:_rightImageView url:loadImage[1] defaultIconName:nil];
    }
    else
    {
        [NetWorkingUtil setImage:_leftImageView url:loadImage[2] defaultIconName:nil];
        [NetWorkingUtil setImage:_centerImageView url:loadImage[0] defaultIconName:nil];
        [NetWorkingUtil setImage:_rightImageView url:loadImage[1] defaultIconName:nil];
    }
}

#pragma mark - 设置每个对应广告对应的广告语
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }
    _leftAdLabel = [[UILabel alloc]init];
    _centerAdLabel = [[UILabel alloc]init];
    _rightAdLabel = [[UILabel alloc]init];
    
    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftAdLabel];
    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerAdLabel];
    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft)
    {
        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _leftAdLabel.textAlignment = NSTextAlignmentRight;
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
        _rightAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    _leftAdLabel.text = _adTitleArray[0];
    _centerAdLabel.text = _adTitleArray[1];
    _rightAdLabel.text = _adTitleArray[2];
}

#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageNameArray.count?_imageNameArray.count:_loadImage.count;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, HIGHT+UISCREENHEIGHT - 10);
    }
    else
    {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}

//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageLabelShowStyle:(AdPageLabelShowStyle)pageLabelShowStyle
{
    if (pageLabelShowStyle == AdPageLabelShowStyleNone) {
        return;
    }
    _pageLabel = [[UILabel alloc]init];
    _pageLabel.font = [UIFont systemFontOfSize:11];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.backgroundColor = [UIColor grayColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    if (pageLabelShowStyle ==  AdPageLabelShowStyleRight)
    {
        _pageLabel.frame = CGRectMake( UISCREENWIDTH - 5-28, HIGHT+UISCREENHEIGHT - 5 - 28, 28, 28);
    }
    _pageLabel.text = [NSString stringWithFormat:@"1/%ld",_loadImage.count];
    _pageLabel.layer.cornerRadius = _pageLabel.frame.size.width/2;
    _pageLabel.layer.masksToBounds = YES;
    _pageLabel.tag = 0;
    [self performSelector:@selector(addPageLabel) withObject:nil afterDelay:0.1f];
}

//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageLabel
{
    [[self superview] addSubview:_pageLabel];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    
    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
//    self.contentOffset = CGPointMake(UISCREENWIDTH * 2, 0);
//    NSLog(@"animalMoveImage = %f",self.contentOffset.x);
    _isTimeUp = YES;
    [HWWeakTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
//    [self scrollViewDidEndDecelerating:self];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%@",_moveTime);
//    NSLog(@"scrollViewDidEndDecelerating = %f",self.contentOffset.x);
    if ([self.delegates respondsToSelector:@selector(gestureClick:)]) {
        [self.delegates gestureClick:_pageControl.currentPage];
    }
    if (self.contentOffset.x == 0)
    {
        //_isTimeUp = NO
        
        currentImage = (currentImage-1)%(_loadImage?_loadImage.count:_imageNameArray.count);
        
        //pageControl
        if (_pageControl) {
            if (!_pageControl.currentPage) {
                _pageControl.currentPage = _loadImage?_loadImage.count-1:_imageNameArray.count-1;
            }
            else
            {
                _pageControl.currentPage = (_pageControl.currentPage - 1)%(_loadImage?_loadImage.count:_imageNameArray.count);
            }
        }
        
        // pageLabel
        if (_pageLabel) {
            // 通过tag计入pageLabel
            if (!_pageLabel.tag) {
                _pageLabel.tag = _loadImage?_loadImage.count-1:_imageNameArray.count-1;
            }
            else
            {
                _pageLabel.tag = (_pageLabel.tag - 1)%(_loadImage?_loadImage.count:_imageNameArray.count);
            }
        }
        
    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
       currentImage = (currentImage+1)%(_loadImage?_loadImage.count:_imageNameArray.count);
        
        if (_pageControl) {
            _pageControl.currentPage = (_pageControl.currentPage + 1)%(_loadImage?_loadImage.count:_imageNameArray.count);
        }
       
        if (_pageLabel) {
            _pageLabel.tag = (_pageLabel.tag + 1)%(_loadImage?_loadImage.count:_imageNameArray.count);
        }
    }
    else
    {
        return;
    }
    
    if (_pageLabel)
    {
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",_pageLabel.tag+1,(unsigned long)(_loadImage?_loadImage.count:_imageNameArray.count)];
    }
    
    NSInteger left,right,center;
    NSInteger count = _loadImage?_loadImage.count:_imageNameArray.count;
    center = _pageLabel?_pageLabel.tag:_pageControl.currentPage;
    left = center?center-1:count-1;
    if (left<0) {
        left = 1;
    }
    right = center==count-1?0:center+1;
    if (right>count-1)
    {
        right = 0;
    }
    
    if (_loadImage)
    {
        [NetWorkingUtil setImage:_leftImageView url:_loadImage[left] defaultIconName:nil];
        [NetWorkingUtil setImage:_centerImageView url:_loadImage[center] defaultIconName:nil];
        [NetWorkingUtil setImage:_rightImageView url:_loadImage[right] defaultIconName:nil];
    }
    else
    {
        _leftImageView.image = [UIImage imageNamed:_imageNameArray[left]];
        
        _centerImageView.image = [UIImage imageNamed:_imageNameArray[center]];
        
        _rightImageView.image = [UIImage imageNamed:_imageNameArray[right]];
    }
    
    _leftAdLabel.text = _adTitleArray[left];
    _centerAdLabel.text = _adTitleArray[center];
    _rightAdLabel.text = _adTitleArray[right];
//    NSLog(@"scrollViewDidEndDecelerating = %f",self.contentOffset.x);
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
//    NSLog(@"scrollViewDidEndDecelerating = %f",self.contentOffset.x);
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp)
    {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    
    if (_isTimer)
    {
       _isTimeUp = NO;
    }
}

- (void)dealloc
{
    _moveTime = nil;
}

- (void)setIsTimer:(BOOL)isTimer
{
    _isTimer = isTimer;
    if (_isTimer&&!_moveTime)
    {
        _moveTime = [HWWeakTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
//        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
    }
}

- (UIImage *)imageWithCacheKey:(NSString *)key
{
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
    if (!image)
    {
        image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:key];
    }
   return image;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
