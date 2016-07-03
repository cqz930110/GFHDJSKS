//
//  WeiSupportTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectDetailsObj;
@class WeiProjectDetailsViewController;
@interface WeiSupportTableViewCell : UITableViewCell
{
    NSMutableArray *_supportMutableArr;
}
@property (nonatomic,strong)NSMutableArray *supportMutableArr;
@property (nonatomic,strong)ProjectDetailsObj *projectDetails;

@property (nonatomic,weak)WeiProjectDetailsViewController *delegate;
@end
