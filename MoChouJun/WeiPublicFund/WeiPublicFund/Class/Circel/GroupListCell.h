//
//  GroupListCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupListCell : UITableViewCell
@property (assign, nonatomic) BOOL isGroupAdvocate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
