//
//  NoExpressReturnTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressObj;
@interface NoExpressReturnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noExpressReturnLab;
@property (weak, nonatomic) IBOutlet UILabel *noExpressDataLab;

@property (nonatomic,strong)ExpressObj *express;
@end
