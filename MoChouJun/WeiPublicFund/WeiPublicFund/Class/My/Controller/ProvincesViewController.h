//
//  ProvincesViewController.h
//  PublicFundraising
//
//  Created by liuyong on 15/10/28.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
#import "CitysViewController.h"
@interface ProvincesViewController : BaseViewController

// 需要传一个字典 然后回保存
@property (strong, nonatomic) NSMutableDictionary *addressDic;
@property (assign, nonatomic) BOOL isOptionCity;
@end
