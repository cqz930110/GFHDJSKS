//
//  SuccessProjectViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/1.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareUtil.h"

@interface SuccessProjectViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *showLab;

@property (nonatomic,assign)NSInteger projectId;
@property (nonatomic,copy)NSArray *projectArr;
@property (nonatomic,copy)NSString *projectStr;

@property (nonatomic,copy)NSString *showStr;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *myTitle;

@property (nonatomic,copy) NSString *editType;

@property (nonatomic,copy) NSString *contentStr;

@property (nonatomic,assign)NSInteger uploadCount;

@property (nonatomic,assign)NSInteger repayCount;
@end
