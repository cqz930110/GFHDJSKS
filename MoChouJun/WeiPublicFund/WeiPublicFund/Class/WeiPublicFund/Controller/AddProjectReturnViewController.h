//
//  AddProjectReturnViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"

@class AddProjectReturnViewController;
@protocol AddProjectReturnViewControllerDelegate <NSObject>

- (void)addReturnSavedReturnUserInfo:(NSDictionary *)userInfo isEdit:(BOOL)isEdit;
@end

@interface AddProjectReturnViewController : BaseViewController

@property (weak, nonatomic) id<AddProjectReturnViewControllerDelegate> delegate;
@property (nonatomic,copy)NSDictionary *editReturnDic;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSString *addType;

@property (nonatomic,assign)int crowdFundId;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSArray *projectImageArr;


@property (nonatomic,copy)NSString *editType;
@end
