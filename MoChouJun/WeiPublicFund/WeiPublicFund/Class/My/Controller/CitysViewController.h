//
//  CitysViewController.h
//  PublicFundraising
//
//  Created by liuyong on 15/11/2.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
#import "DistrictViewController.h"
@interface CitysViewController : BaseViewController

@property (nonatomic,strong)NSString *provinceId;
@property (nonatomic,strong)NSString *provinceName;

@property (strong, nonatomic) NSMutableDictionary *addressDic;
@property (assign, nonatomic) BOOL isOptionCity;
@end
