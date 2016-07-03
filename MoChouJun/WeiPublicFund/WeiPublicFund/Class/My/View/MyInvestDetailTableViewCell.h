//
//  MyInvestDetailTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInvestDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myInvestNameLab;
@property (weak, nonatomic) IBOutlet UILabel *myInvestDetailLab;
@property (copy, nonatomic) NSString *content;
@end
