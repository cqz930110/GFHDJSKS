//
//  SupportAllTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportReturn;
@interface SupportAllTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *returnAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *returnContentLab;

@property (strong, nonatomic) SupportReturn *support;
@end
