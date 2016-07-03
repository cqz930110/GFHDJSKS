//
//  GroupOwnerView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSBuddy;
@protocol GroupOwnerViewDelegate<NSObject>
- (void)gotoGroupOwnerDetail:(PSBuddy *)buddy;
@end

@interface GroupOwnerView : UIView
@property (strong, nonatomic) PSBuddy *buddy;
@property (weak, nonatomic) id<GroupOwnerViewDelegate> delegate;
@end
