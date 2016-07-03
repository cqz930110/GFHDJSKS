//
//  SupportProjectTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SupportProjectCellStyle)
{
    SupportProjectCellStyleDetail,
    SupportProjectCellStylePay,
    SupportProjectCellStyleReturn
};
@class SupportReturn;
@class SupportProjectTableViewCell;

// 只能是Controller
@protocol SupportProjectTableViewCellDelegate <NSObject,NSCoding, UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment>

@optional
- (void)supportProjectCellReturnPeople:(SupportProjectTableViewCell *)cell;

@end

@interface SupportProjectTableViewCell : UITableViewCell
@property (nonatomic,strong)SupportReturn *support;
@property (weak, nonatomic) id<SupportProjectTableViewCellDelegate> delegate;
@property (assign, nonatomic) SupportProjectCellStyle cellStyle; //默认是detail
@property (assign, nonatomic) NSInteger projectStates;

@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIImageView *supportImageView;

@property (nonatomic,assign) NSInteger projectUerId;
@end
