//
//  BaseViewController.h
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "NetWorkingUtil.h"
#import "NoMsgView.h"
@interface BaseViewController : UIViewController

@property (nonatomic,assign) BOOL hideNaviBar;//defult is no viewwillappear
@property (nonatomic,assign) BOOL hideBottomBar;//defult is no
@property (nonatomic,assign) BOOL screenLayout;//defult is no
@property (strong, nonatomic) NetWorkingUtil *httpUtil;
@property (assign, nonatomic) RefershState refershState;
@property (nonatomic,assign)BOOL hideNoMsg;
@property (nonatomic,strong)NoMsgView *noMsgView;
// navi bar item
- (UIBarButtonItem *)backBarItem;
- (void)backAction;

- (UIBarButtonItem *)setupBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft;
- (UIBarButtonItem *)setupBarButtomItemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImaegName target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft;

// refresh
- (void)setupRefreshWithTableView:(UITableView *)tableView;
- (void)setupFooterRefresh:(UITableView *)tableView;
- (void)setupHeaderRefresh:(UITableView *)tableView;

- (void)headerRefreshloadData;
- (void)footerRefreshloadData;
@end
