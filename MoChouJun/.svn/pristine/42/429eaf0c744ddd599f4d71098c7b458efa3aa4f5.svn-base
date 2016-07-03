/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
@class ApplyFriendCell;
@protocol ApplyFriendCellDelegate <NSObject>
- (void)applyCellAddFriend:(ApplyFriendCell *)cell;
@end

@interface ApplyFriendCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headerImageView;//头像
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UILabel *contentLabel;//详情
@property (strong, nonatomic) UIButton *addButton;//接受按钮
//@property (strong, nonatomic) UIButton *refuseButton;//拒绝按钮
@property (strong, nonatomic) UIView *bottomLineView;

@property (nonatomic) id<ApplyFriendCellDelegate> delegate;
@property (assign, nonatomic) NSInteger applyState;

+ (CGFloat)heightWithContent:(NSString *)content;
@end


