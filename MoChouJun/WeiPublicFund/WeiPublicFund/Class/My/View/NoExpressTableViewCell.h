//
//  NoExpressTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressObj;
@interface NoExpressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noExpressMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *noExpressContentLab;
@property (weak, nonatomic) IBOutlet UILabel *noExpressDataLab;

@property (nonatomic,strong)ExpressObj *express;
@end
