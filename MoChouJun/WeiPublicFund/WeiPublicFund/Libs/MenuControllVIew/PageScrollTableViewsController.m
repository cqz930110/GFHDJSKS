//
//  PageScrollTableViewsController.m
//  ScrollViewAndTableView
//
//  Created by fantasy on 16/5/14.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "PageScrollTableViewsController.h"

//controller
#import "PageTableController.h"

//view
#import "MenuView.h"

//lib or others
#import "Common.h"
#import "AdScrollView.h"

#import "AppDelegate.h"
#import "TabBarController.h"

#import "StartFirstProjectViewController.h"
#import "AppDelegate.h"

#import "WeiProjectDetailsViewController.h"
#import "IphoneBindingViewController.h"
#import "CheckNameViewController.h"
#import "PageWebViewController.h"

@interface PageScrollTableViewsController ()<UIScrollViewDelegate,AdScrollViewProtocolDelegate,UIAlertViewDelegate>

/** 分享按钮 */
@property (nonatomic, strong) UIButton                   *sharedBtn;
/** 导航条的背景view */
@property (nonatomic, strong) UIView                     *naviView;
/** 导航条上的title */
@property (nonatomic, strong)UILabel *titleLab;

@property (strong, nonatomic) NSArray * titleArray;

@property (weak, nonatomic) UIScrollView * scrollView;
@property (weak, nonatomic) MenuView * menuView;
@property (weak, nonatomic) UIView *  headerView;

//偏移量
@property (assign, nonatomic) CGFloat scrollViewY;
@property (nonatomic,strong)AdScrollView *imageScrollView;
@property (nonatomic,strong)NSMutableArray *imageUrl;
@property (nonatomic,strong)NSMutableArray *tagIdArr;
@end

@implementation PageScrollTableViewsController

- (instancetype)initWithTitleArray:(NSArray *)titleArray Image:(NSMutableArray *)imageUrlArr tagId:(NSMutableArray *)tagIdArr{
  
  if (self = [super init]) {
    
    NSAssert(titleArray.count > 0, @"");
    _scrollViewY = -kScrollViewOriginY;
    self.titleArray = titleArray;
    self.imageUrl = imageUrlArr;
    self.tagIdArr = tagIdArr;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  return self;
  
}

- (void)viewDidLoad{
  
  [super viewDidLoad];
  
  [self setupAllViews];
  [self addNavi];
}
- (void)setupAllViews{
 
  @weakify(self);
  UIScrollView * scrollView = [[UIScrollView alloc]init];
  scrollView.backgroundColor = [UIColor whiteColor];
  scrollView.bounces = NO;
  scrollView.delegate = self;
  scrollView.pagingEnabled = YES;
  scrollView.frame = self.view.bounds;
  scrollView.contentSize = CGSizeMake(_titleArray.count * kScreenWidth,0);
  _scrollView = scrollView;
  [self.view addSubview:scrollView];
  
  for (int i = 0; i < _titleArray.count; i++) {
    
    
    PageTableController * pageController = [[PageTableController alloc]initWithStyle:UITableViewStyleGrouped];
    pageController.tableViewDidScroll = ^(CGFloat tableViewOffsetY){
      @strongify(self);
      [self tableViewDidScroll:tableViewOffsetY];
      
    };
      pageController.tableViewWillBeginDragging = ^(CGFloat tableViewOffsetY){
          @strongify(self);
          [self tableViewWillBeginDragging:tableViewOffsetY];
          
      };
      pageController.tableViewWillBeginDecelerating = ^(CGFloat tableViewOffsetY){
          @strongify(self);
          [self tableViewWillBeginDecelerating:tableViewOffsetY];
          
      };
      pageController.tableViewDidEndDragging = ^(CGFloat tableViewOffsetY){
          @strongify(self);
          [self tableViewDidEndDragging:tableViewOffsetY];
          
      };
      pageController.tableViewDidEndDecelerating = ^(CGFloat tableViewOffsetY){
          @strongify(self);
          [self tableViewDidEndDecelerating:tableViewOffsetY];
          
      };
    pageController.tableView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    pageController.numOfController = i+1;
    pageController.tableView.frame = CGRectMake(i*kScreenWidth, kMenuViewHeight, kScreenWidth, kScreenHeight - kMenuViewHeight - kNavigationHeight+15);
    pageController.tableView.contentInset = UIEdgeInsetsMake(kScrollViewOriginY, 0, 0, 0);
    [scrollView addSubview:pageController.tableView];
    [self addChildViewController:pageController];
    
  }
  
    UIView * headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight);
    _headerView = headerView;
    [self.view addSubview:headerView];

    _imageScrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
    _imageScrollView.delegates = self;
    [self createScrollViewImageUrls:_imageUrl];
    [headerView addSubview:_imageScrollView];
  
  MenuView * menuView = [[MenuView alloc]initWithTitleArray:_titleArray andDidClickButtonBlock:^(int buttonIndex) {
    @strongify(self);
    [self didClickMenuButton:buttonIndex];
    
  }];
  menuView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), kScreenWidth, kMenuViewHeight);
  _menuView = menuView;
  [self.view addSubview:menuView];
}

#pragma mark - AdscrollView
- (void)createScrollViewImageUrls:(NSMutableArray*)imageUrls
{
    if (imageUrls.count == 0) {
        _imageScrollView.imageNameArray = @[@"ProjectCrowed.png",@"ProjectCrowed.png",@"ProjectCrowed.png"];
    }else{
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 0; i < imageUrls.count; i ++) {
            imageArr[i] = [imageUrls[i] objectForKey:@"Image"];
        }
        _imageScrollView.loadImage = imageArr;
    }
    
    _imageScrollView.isTimer = YES;
    _imageScrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    //    [_adScrollView setAdTitleArray:adTitles withShowStyle:AdTitleShowStyleLeft];
    _imageScrollView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imageScrollView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)gestureClick:(NSInteger)index
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _headerView.tag = index;
    [_headerView addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if (_headerView.tag == _imageUrl.count - 1) {
        if ([[_imageUrl[0] objectForKey:@"TypeId"] integerValue] == 0) {
            PageWebViewController *pageWebVC = [PageWebViewController new];
            pageWebVC.urlStr = [_imageUrl[0] objectForKey:@"Url"];
            [self.navigationController pushViewController:pageWebVC animated:YES];
        }else if ([[_imageUrl[0] objectForKey:@"TypeId"] integerValue] == 1){
            WeiProjectDetailsViewController *weiProjectDetailsVC = [WeiProjectDetailsViewController new];
            weiProjectDetailsVC.projectId = [[_imageUrl[0] objectForKey:@"Url"] intValue];
            [self.navigationController pushViewController:weiProjectDetailsVC animated:YES];
        }
    }else{
        if ([[_imageUrl[_headerView.tag + 1] objectForKey:@"TypeId"] integerValue] == 0) {
            PageWebViewController *pageWebVC = [PageWebViewController new];
            NSLog(@"%@",[_imageUrl[_headerView.tag + 1] objectForKey:@"Url"]);
            pageWebVC.urlStr = [_imageUrl[_headerView.tag + 1] objectForKey:@"Url"];
            [self.navigationController pushViewController:pageWebVC animated:YES];
            
        }else if ([[_imageUrl[_headerView.tag + 1] objectForKey:@"TypeId"] integerValue] == 1){
            WeiProjectDetailsViewController *weiProjectDetailsVC = [WeiProjectDetailsViewController new];
            weiProjectDetailsVC.projectId = [[_imageUrl[_headerView.tag + 1] objectForKey:@"Url"] intValue];
            [self.navigationController pushViewController:weiProjectDetailsVC animated:YES];
        }
    }
}

- (void)tableViewDidScroll:(CGFloat)tableViewOffsetY{
  
  CGFloat everyChange = tableViewOffsetY - _scrollViewY;
  _scrollViewY = tableViewOffsetY;
    if (_scrollViewY >= 0) {//悬浮在顶部
        CGFloat offsetY = tableViewOffsetY;
        
        //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
        CGFloat startF = -175;
        //初始的偏移量Y值为 顶部俩个控件的高度
        CGFloat initY =  175;
        //缺少的那一段渐变Y值
        CGFloat lackY = initY + startF;
        //自定义导航条高度
        CGFloat naviH = 64;
        
        //渐隐alpha值
        CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - lackY) ;
        if (alphaScaleShow > 1.0)
        {
            //显示导航条
            [self.sharedBtn setImage:[UIImage imageNamed:@"add_start2"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.04 animations:^{
                self.naviView.alpha = 1;
                self.titleLab.hidden = NO;
            }];
            _headerView.y = -kHeaderViewHeight;
            _menuView.y   = kNavigationHeight;
        }
    } else if (_scrollViewY <= -kScrollViewOriginY){//固定在下面
    _headerView.y = 0;
    _menuView.y   = CGRectGetMaxY(_headerView.frame);
  } else {//随着移动
      [self.sharedBtn setImage:[UIImage imageNamed:@"add_Start"] forState:UIControlStateNormal];
      self.naviView.alpha = 0;
      self.titleLab.hidden = YES;
    _headerView.y -= everyChange;
    _menuView.y   =  CGRectGetMaxY(_headerView.frame);
    
  }

}

- (void)tableViewDidEndDecelerating:(CGFloat)tableViewOffsetY{
    
}

- (void)tableViewDidEndDragging:(CGFloat)tableViewOffsetY{
    
}

- (void)tableViewWillBeginDragging:(CGFloat)tableViewOffsetY{
    
}

- (void)tableViewWillBeginDecelerating:(CGFloat)tableViewOffsetY{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didClickMenuButton:(int)buttonIndex{
  [self.scrollView setContentOffset:CGPointMake(buttonIndex * kScreenWidth, 0) animated:YES];
    int index = [_tagIdArr[buttonIndex] intValue];
    for (PageTableController * pageController in self.childViewControllers) {
        [pageController updateTableViewIndex:index];
    }
  
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  if (scrollView == self.scrollView) {
    
    if (_scrollViewY >= -kScrollViewOriginY) {//menuView滑动了
      
      for (PageTableController * pageController in self.childViewControllers) {
        pageController.tableView.contentOffset = CGPointMake(0, _scrollViewY);
      }
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
  if (scrollView == self.scrollView) {
    
    int index = scrollView.contentOffset.x / kScreenWidth;
    [_menuView updateIndexButtonStatus:index];
      int indexs = [_tagIdArr[index] intValue];
      for (PageTableController * pageController in self.childViewControllers) {
          [pageController updateTableViewIndex:indexs];
      }
  }
  
}

- (NSMutableArray *)imageUrl
{
    if (!_imageUrl) {
        _imageUrl = [NSMutableArray array];
    }
    return _imageUrl;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc]init];
    }
    return _titleArray;
}

- (NSMutableArray *)tagIdArr
{
    if (!_tagIdArr) {
        _tagIdArr = [NSMutableArray array];
    }
    return _tagIdArr;
}
//   添加山寨导航条
- (void)addNavi
{
    //初始化山寨导航条
    if (self.naviView == nil) {
        self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        self.naviView.backgroundColor = [UIColor colorWithHexString:@"#FBFD4E"];
        self.naviView.alpha = 0.0;
        [self.view addSubview:self.naviView];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 33, 100, 15)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"首页";
        self.titleLab.hidden = YES;
        [self.view addSubview:self.titleLab];
    }
    
    //分享按钮
    if (self.sharedBtn == nil)
    {
        self.sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sharedBtn.frame = CGRectMake(self.view.frame.size.width - 51, 20, 40, 40);
        [self.sharedBtn setImage:[UIImage imageNamed:@"add_Start"] forState:UIControlStateNormal];
        [self.sharedBtn addTarget:self action:@selector(sharedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sharedBtn];
    }
}

- (void)sharedBtnClick
{
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"Personal/Setting" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (IsStrEmpty([dic objectForKey:@"IdNumber"]) && IsStrEmpty([dic objectForKey:@"Mobile"])){
                [MBProgressHUD dismissHUDForView:self.view];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要实名认证，且绑定手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
                alert.tag = 40000;
                [alert show];
            }else if (IsStrEmpty([dic objectForKey:@"IdNumber"])){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要实名认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
                alert.tag = 20000;
                [alert show];
                [MBProgressHUD dismissHUDForView:self.view];
            }else if (IsStrEmpty([dic objectForKey:@"Mobile"])) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"需要绑定手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
                alert.tag = 10000;
                [alert show];
                [MBProgressHUD dismissHUDForView:self.view];
            }else if([[dic objectForKey:@"IsAbleCreateCF"] integerValue] == 1){
                [MBProgressHUD showMessag:@"你有项目在筹资中，等成功后再来哦" toView:self.view];
                [MBProgressHUD dismissHUDForView:self.view];
            }else if([[dic objectForKey:@"IsAbleCreateCF"] integerValue] == 0){
                [MBProgressHUD showMessag:@"您已被加入黑名单，不能发布项目" toView:self.view];
                [MBProgressHUD dismissHUDForView:self.view];
            }else{
                [MBProgressHUD dismissHUDForView:self.view];
                StartFirstProjectViewController *startFirstVC = [StartFirstProjectViewController new];
                startFirstVC.typeId = @"home";
                [self.navigationController pushViewController:startFirstVC animated:YES];
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            [MBProgressHUD dismissHUDForView:self.view];
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            IphoneBindingViewController *iphoneBindingVC = [[IphoneBindingViewController alloc] init];
            [self.navigationController pushViewController:iphoneBindingVC animated:YES];
        }
    }else if (alertView.tag == 20000 || alertView.tag == 40000){
        if (buttonIndex == 1) {
            CheckNameViewController *checkNameVC = [[CheckNameViewController alloc] init];
            [self.navigationController pushViewController:checkNameVC animated:YES];
        }
    }
}


@end
