//
//  SupportMyProjectTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportMyProjectTableViewCell;
@protocol SupportMyProjectTableViewCellDelegate<NSObject>
- (void)supportProjectCellDidClikeIcon:(SupportMyProjectTableViewCell *)cell;
@end

@class SupportedProject;
@interface SupportMyProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *supportPeopleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *supportPropleImageView;
@property (weak, nonatomic) IBOutlet UILabel *supportPeopleName;
@property (weak, nonatomic) IBOutlet UILabel *supportPeopleAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *supportPeopleDataLab;
@property (nonatomic,strong)SupportedProject *supportMyProject;
@property (weak, nonatomic) id<SupportMyProjectTableViewCellDelegate> delegate ;
@end
