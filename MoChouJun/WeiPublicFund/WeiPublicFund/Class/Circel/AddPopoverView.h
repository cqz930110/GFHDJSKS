//
//  AddPopoverView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/14.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,AddActionType)
{
    AddActionTypeFriend,
    AddActionTypeGroup
};
@class AddPopoverView;
@protocol AddPopverViewDelegate <NSObject>
- (void)addPopoverView:(AddPopoverView *)popView addActionType:(AddActionType)addActionType;
@end
@interface AddPopoverView : UIView
@property (weak, nonatomic) id<AddPopverViewDelegate> delegate;
- (void)showAnimation;
@end
