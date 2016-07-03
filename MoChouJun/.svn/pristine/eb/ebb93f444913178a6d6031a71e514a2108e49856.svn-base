//
//  StartSecondProjectViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 16/4/6.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"

@class StartSecondProjectViewController;
@protocol StartSecondProjectViewControllerDelegate <NSObject>

- (void)startSecondProjectViewInfo:(NSDictionary *)userInfo;
@end

@interface StartSecondProjectViewController : BaseViewController

@property (nonatomic,strong)NSDictionary *startProjectDic;
@property (nonatomic,strong)NSDictionary *draftProjectDic;
@property (nonatomic,assign)NSInteger draftId;

@property (nonatomic,weak)id<StartSecondProjectViewControllerDelegate>delegate;
@property (nonatomic,strong)NSDictionary *returnAllDic;
@end
