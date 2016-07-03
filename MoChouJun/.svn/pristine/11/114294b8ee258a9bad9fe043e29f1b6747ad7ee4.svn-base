//
//  WithdrawOptionView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/30.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WithdrawOptionView;
typedef NS_ENUM(NSInteger,WithdrawType)
{
    WithdrawTypeNone,
    WithdrawTypeWeixin,
    WithdrawTypeAlipay,
    WithdrawTypeBank
};
@protocol WithdrawOptionViewDelegate <NSObject>
- (void)withdrawOptionViewAddAccount:(WithdrawOptionView *)view;

- (void)withdrawOptionView:(WithdrawOptionView *)view optionWithdrawInfomation:(id)withdrawInfomation;
@end

@interface WithdrawOptionView : UIView
@property (assign,nonatomic) WithdrawType withdrawType;
@property (strong, nonatomic) NSArray *withdrawTypeDataSource;
@property (weak, nonatomic) id<WithdrawOptionViewDelegate> delegate;
@end
