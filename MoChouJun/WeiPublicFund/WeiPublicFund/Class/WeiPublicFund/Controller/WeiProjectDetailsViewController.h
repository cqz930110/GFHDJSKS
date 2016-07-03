//
//  WeiProjectDetailsViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
@class WeiSupportTableViewCell;
@class ProjectTableViewCell;
@class ProjectDetailsObj;
@class NoReturnSupportTableViewCell;

typedef NS_ENUM(NSInteger,DetailShowType)
{
    DetailShowTypeReal,
    DetailShowTypeReview
};

@interface SupportReturnMamager : NSObject
@property (assign, nonatomic) BOOL isOpen;// defalult is NO;
@property (strong, nonatomic) NSArray *supportReturns;
@end

@interface WeiProjectDetailsViewController : BaseViewController
@property (nonatomic, assign) int projectId;
@property (assign, nonatomic) DetailShowType showType;

@property (nonatomic,strong)NSString *type;

/**
 *  预览
 */
- (void)reviewProjectDetail:(ProjectDetailsObj *)projectDetails supportReturns:(NSArray *)supportReturns;
//   WeiSupport delegate
- (void)weiSupportTableViewCell:(WeiSupportTableViewCell *)cell supportProject:(id)project;

@end

