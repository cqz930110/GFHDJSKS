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
@class BlackBuddy;
@class PSBuddy;
@class PSGroup;
@protocol BaseTableCellDelegate;
@interface BaseTableViewCell : UITableViewCell
{
    UILongPressGestureRecognizer *_headerLongPress;
}

@property (weak, nonatomic) id<BaseTableCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) NSString *username;

// 本地
@property (strong, nonatomic) PSBuddy *buddy;
@property (strong, nonatomic) PSGroup *group;
@property (strong, nonatomic) BlackBuddy *blackBuddy;
@end

@protocol BaseTableCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end