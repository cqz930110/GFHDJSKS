//
//  WeiSponsortTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLAttributedLabel;
@class WeiSponsortTableViewCell;
@class ProjectDetailsObj;

static CGFloat const kMargin = 10.f;
static NSUInteger const numberOfLines = 100;

@protocol WeiSponsortTableViewCellDelegate <NSObject>

- (void)tableViewCell:(WeiSponsortTableViewCell *)cell model:(ProjectDetailsObj *)model numberOfLines:(NSUInteger)numberOfLines;

@end

@interface WeiSponsortTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playVideoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *playFromLab;

@property (nonatomic, weak) id<WeiSponsortTableViewCellDelegate> delegate;
@property (nonatomic, strong) ProjectDetailsObj *model;
@property (nonatomic, strong) TLAttributedLabel *contentLab;

@property (nonatomic,assign)BOOL hideState;

@end
