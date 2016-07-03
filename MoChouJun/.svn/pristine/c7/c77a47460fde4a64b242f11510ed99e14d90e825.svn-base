//
//  WNXScrollHeadView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/3.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  详情页面的顶部View,用于展示动画于图片

#import "WNXScrollHeadView.h"
#import "UIImageView+WebCache.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"

@interface WNXScrollHeadView() <UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIPageControl *pageView;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic,assign)NSInteger pageIndex;

@end

@implementation WNXScrollHeadView

//便利构造方法
+ (instancetype)scrollHeadViewWithImages:(NSArray *)images
{
    WNXScrollHeadView *headView = [[self alloc] init];
    
    headView.images = images;
    
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
    }

    return self;
}

//初始化控件
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    /**
     *在setImages， setFrame，和layoutSubViews都尝试了下加载都不可以，因为pageView需要和self在同一个父控件中
     *只有在即将显示到父控件的时候父控件不为空，所以在这个方法初始化pageView
     */
    //初始化pageView
    self.pageView = [[UIPageControl alloc] init];
    self.pageView.hidesForSinglePage = YES;
    CGFloat x = 0;
    CGFloat y = self.bounds.size.height - 25;
    CGFloat w = self.bounds.size.width;
    CGFloat h = 25;
    self.pageView.frame = CGRectMake(x, y, w, h);
    [self.superview insertSubview:self.pageView aboveSubview:self];
    
    NSInteger count = self.images.count;
    //NSAssert(count > 0, @"最少有1个图片");
    int i = 0;
//    if (![self.images[0] isKindOfClass:[UIImage class]]) {
    
            //获取网络请求路径
            for (int j = 0; j < self.images.count; j ++) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                if ([self.images[j] isKindOfClass:[NSString class]]) {
                    NSString *urlStr = self.images[j];
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"project-默认"]];
                    CGFloat w = self.bounds.size.width;
                    CGFloat h = self.bounds.size.height;
                    imageV.frame = CGRectMake(i * w, 0, w, h);
                    
                    [self insertSubview:imageV atIndex:i];
                    
                }else if ([self.images[j] isKindOfClass:[UIImage class]]){
                    UIImage *image = self.images[j];
                    imageV.image = image;
                    CGFloat w = self.bounds.size.width;
                    CGFloat h = self.bounds.size.height;
                    imageV.frame = CGRectMake(i * w, 0, w, h);
                    [self insertSubview:imageV atIndex:i];
                }
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
                _pageIndex = 0;
                [self addGestureRecognizer:tap];
                i++;
            }
//            NSURL *url = [NSURL URLWithString:urlStr];
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
//            imageV.contentMode = UIViewContentModeScaleAspectFill;
//            [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"project-默认"]];
//            imageV.clipsToBounds = YES;
            //oa_loding6
            
            
            
            
        
//    }else{
//        for (UIImage *image in self.images) {
//            //获取网络请求路径
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
//            imageV.contentMode = UIViewContentModeScaleAspectFill;
//            imageV.image = image;
//            imageV.clipsToBounds = YES;
//            //oa_loding6
//            
//            CGFloat w = self.bounds.size.width;
//            CGFloat h = self.bounds.size.height;
//            imageV.frame = CGRectMake(i * w, 0, w, h);
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//            _pageIndex = 0;
//            [self addGestureRecognizer:tap];
//            
//            
//            i++;
//        }
//    }
    
    
    //初始化自定义的导航view
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w * count, self.bounds.size.height)];
    self.naviView.backgroundColor = [UIColor colorWithHexString:@"#FBFD4E"];
    self.naviView .alpha = 0.0;
    self.naviView = self.naviView;
    [self.superview insertSubview:self.naviView aboveSubview:self.pageView];
    
    if (count <= 1) return;
    
    //如果图片个数大于1设置scrollView的contentSize和pageView的num,根据图片
    self.pageView.numberOfPages =count;
    self.contentSize = CGSizeMake(count * self.bounds.size.width, 0);

}

- (void)headViewDidScroll:(CGRect)rect headViewHeight:(CGFloat)height
{
    CGFloat x = 0;
    CGFloat y = rect.origin.y - 25 + height;
    CGFloat w = self.bounds.size.width;
    CGFloat h = 25;
    self.pageView.frame = CGRectMake(x, y, w, h);
    
    CGRect navViewRect = self.naviView.frame;
    navViewRect.origin.y = rect.origin.y;
    self.naviView.frame = navViewRect;
}

#pragma mark - ScrollViewDelegate
//监听scrollView滚动，改变pageView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.pageView.currentPage = offsetX / self.bounds.size.width;
    _pageIndex = self.pageView.currentPage;
}

- (void)tapClick:(UITapGestureRecognizer *)sender
{
    // 查看图片 //删除功能
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:_pageIndex];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if (self.delegates) {
        UIViewController *vc =  (UIViewController *)self.delegates;
        [vc presentViewController:nc animated:YES completion:nil];
    }else{
        UIViewController *vc =  (UIViewController *)self.delegatesd;
        [vc presentViewController:nc animated:YES completion:nil];
    }
    
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    NSInteger number;
//    if ([self.images[0] isKindOfClass:[UIImage class]]) {
//        number = self.images.count;
//    }else{
//        
//    }
    number = self.images.count;
    return number;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (![self.images[0] isKindOfClass:[UIImage class]]) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.images[index]]];
        return photo;
    }else{
        MWPhoto *photo = [MWPhoto photoWithImage:self.images[index]];
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (![self.images[0] isKindOfClass:[UIImage class]]) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.images[index]]];
        return photo;
    }else{
        MWPhoto *photo = [MWPhoto photoWithImage:self.images[index]];
        return photo;
    }
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

@end
