//
//  ZHBPickerView.h
//  picker
//
//  Created by 庄彪 on 15/5/14.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBPickerView;

@protocol ZHBPickerViewDataSource <NSObject>

@required
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView;

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component;

@end

@protocol ZHBPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content;
- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView;
@end

@interface ZHBPickerView : UIView

@property (nonatomic, weak) id<ZHBPickerViewDelegate> delegate;

@property (nonatomic, weak) id<ZHBPickerViewDataSource> dataSource;

+ (instancetype)pickerView;

@end
