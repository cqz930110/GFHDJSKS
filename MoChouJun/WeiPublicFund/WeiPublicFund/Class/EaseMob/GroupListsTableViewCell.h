//
//  GroupListsTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSGroup;
@interface GroupListsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLab;
@property (weak, nonatomic) IBOutlet UILabel *groupLastMsgLab;
@property (weak, nonatomic) IBOutlet UILabel *groupLastTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;


@property (strong, nonatomic) PSGroup *group;
@end
