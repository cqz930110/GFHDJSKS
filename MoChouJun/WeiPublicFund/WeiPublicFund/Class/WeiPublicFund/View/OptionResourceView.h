//
//  OptionResourceView.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OptionResourceView;
@protocol OptionResourceViewDelegate <NSObject>
- (void)optionResourceClikeImage:(OptionResourceView*)optionResourceView;
- (void)optionResourceClikeRecord:(OptionResourceView*)optionResourceView;
@end

@interface OptionResourceView : UIView
@property (weak, nonatomic) id<OptionResourceViewDelegate> delegate;
//@property (strong, nonatomic) NSMutableArray *selectImages;
- (void)reloadData;
@end
