//
//  StartNoReturnViewController.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/30.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseViewController.h"

@interface MySupportPeopleViewController : BaseViewController
// 无回报传项目id
@property (nonatomic,assign)int crowdFundId;
// 有回报传支持人数
@property (nonatomic,strong)NSArray *startNoProjectArr;
@end
