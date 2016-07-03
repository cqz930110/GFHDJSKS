//
//  MenuView.m
//  ScrollViewAndTableView
//
//  Created by fantasy on 16/5/14.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "MenuView.h"

#import "Masonry.h"
#import "Common.h"

#import "PageTableController.h"

@interface MenuView ()

@property (strong, nonatomic) NSArray * titleArray;

@property (weak, nonatomic) UIScrollView * scrollView;

@property (weak, nonatomic) UIButton * selectedButton;

@property (copy, nonatomic) DidSelectedButtonBlock didClickButton;

@property (assign, nonatomic) CGFloat allButtonWidth;

@end

@implementation MenuView

- (instancetype)initWithTitleArray:(NSArray *)titleArray andDidClickButtonBlock:(DidSelectedButtonBlock)didClickButton{
  
  if (self = [super init]) {
    
    NSAssert(titleArray.count > 0, @"");
    
    _titleArray = titleArray;
    
    _didClickButton = didClickButton;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.allButtonWidth = 0;
    [self setupViews];
  }
  return self;
  
}

- (void)setupViews{
  
  UIScrollView * scrollView = [[UIScrollView alloc]init];
  scrollView.bounces = YES;
  scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView = scrollView;
  [self addSubview:scrollView];
  [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.top.and.left.and.right.and.bottom.mas_equalTo(0);
    
  }];
  
  UIView * containerView = [[UIView alloc]init];
  containerView.tag = 100;
  [scrollView addSubview:containerView];
  [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.top.and.bottom.and.left.and.right.mas_equalTo(0);
    make.height.mas_equalTo(scrollView.mas_height);
  
  }];
  
  UIButton * lastButton = nil;
  
  for (int i = 0; i<self.titleArray.count; i++) {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.tag = i;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#6C6C6C"] forState:UIControlStateNormal];
    [self buttonAddMovingLine:button];
    [button sizeToFit];
    [containerView addSubview:button];
    
    if (i == 0) {
      
      [button setTitleColor:[UIColor colorWithHexString:@"#F35C56"] forState:UIControlStateNormal];
      [self buttonWithMovingLien:button andHide:NO];
      _selectedButton = button;
      
      [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(button.width + 25);
        make.top.and.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        
      }];
    } else {
      [self buttonWithMovingLien:button andHide:YES];
      [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lastButton.mas_right);
        make.top.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(button.width + 25);
        
        if (i == self.titleArray.count - 1) {
         
          make.right.mas_equalTo(containerView.mas_right);
          
        }
        
      }];
    
    }
    
    lastButton = button;
    CGSize buttonSize = [button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _allButtonWidth +=buttonSize.width;
    
  }
  
  NSAssert(_allButtonWidth > 0, @"");
  
  if (_allButtonWidth < kScreenWidth) {
    
    [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
      
      make.centerX.mas_equalTo(self.scrollView.mas_centerX);
      make.top.mas_equalTo(0);
      make.height.mas_equalTo(self.scrollView.mas_height);
      make.width.mas_equalTo(_allButtonWidth);
      
    }];
    
  }
  
  UIView * sepView = [[UIView alloc]init];
  sepView.backgroundColor = RGBcolor(200, 200, 200);
  [self addSubview:sepView];
  [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.right.and.left.and.bottom.mas_equalTo(0);
    make.height.mas_equalTo(0.5);
    
  }];
  
}

- (void)didClickButton:(UIButton *)button{
  
  if (button == _selectedButton) {
    return;
  }
  [self buttonWithMovingLien:_selectedButton andHide:YES];
  [self letTheSelectedButtonCenter:button];
  
  [_selectedButton setTitleColor:[UIColor colorWithHexString:@"#6C6C6C"] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithHexString:@"#F35C56"] forState:UIControlStateNormal];
  _selectedButton = button;
  [self buttonWithMovingLien:_selectedButton andHide:NO];
  if (self.didClickButton) {
    self.didClickButton((int)button.tag);
  }
}

- (void)buttonAddMovingLine:(UIButton *)button{
  
  UIView * movingLine = [[UIView alloc]init];
  movingLine.backgroundColor = [UIColor colorWithHexString:@"#F35C56"];
  movingLine.tag = 100;
  [button addSubview:movingLine];
  [movingLine mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.and.right.mas_equalTo(5);
    make.bottom.mas_equalTo(0);
    make.height.mas_equalTo(2);
    
  }];
}
- (void)buttonWithMovingLien:(UIButton *)button andHide:(BOOL)hide{

  for (UIView * view in button.subviews) {
    if (view.tag == 100) {
      view.hidden = hide;
    }
  }
  
}

- (void)letTheSelectedButtonCenter:(UIButton *)button{
  
  if (self.allButtonWidth < kScreenWidth) {
    return;
  }
  
  CGFloat scrollX = button.center.x - kScreenWidth/2;
  
  if (scrollX<0) {
    
    scrollX=0;
    
  } else if (scrollX > self.scrollView.contentSize.width - kScreenWidth){
  
    scrollX = self.scrollView.contentSize.width - kScreenWidth;
    
  } else {
  
  }
  [self.scrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

- (void)updateIndexButtonStatus:(int)updateIndex{
  
  for (UIView * containView in self.scrollView.subviews) {
    
    if (containView.tag == 100) {
      
      for (UIButton * button in containView.subviews) {
        
        if (button.tag == updateIndex) {
          [self didClickButton:button];
          break;
        }
      }
      break;
    }
  }
}

@end
