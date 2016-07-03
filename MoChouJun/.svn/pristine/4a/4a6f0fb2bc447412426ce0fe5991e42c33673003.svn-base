//
//  ZHBPickerView.m
//  picker
//
//  Created by 庄彪 on 15/5/14.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "ZHBPickerView.h"

@interface ZHBPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)didClickSelectButton:(UIBarButtonItem *)sender;

- (IBAction)didClickCancelButton:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableDictionary *contents;

@end

@implementation ZHBPickerView

#pragma mark -
#pragma mark Life Cycle

- (void)awakeFromNib {
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
}

#pragma mark -
#pragma mark Public Methods
+ (instancetype)pickerView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

#pragma mark -
#pragma mark UIPickerView DataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource pickerView:self titlesForComponent:component].count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.dataSource numberOfComponentsInPickerView:self];
}

#pragma mark -
#pragma mark UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [[self.dataSource pickerView:self titlesForComponent:component] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self.contents setObject:[[self.dataSource pickerView:self titlesForComponent:component] objectAtIndex:row] forKey:@(component)];
}

#pragma mark -
#pragma mark Event Response

- (IBAction)didClickSelectButton:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectContent:)]) {
        NSString *content = @"";
        for (NSInteger component = 0; component < self.picker.numberOfComponents; component ++) {
            if ([self.contents objectForKey:@(component)]) {
                content = [content stringByAppendingString:[self.contents objectForKey:@(component)]];
            } else {
                content = [content stringByAppendingString:@""];
            }
            
        }
        
        [self.delegate pickerView:self didSelectContent:content];
    }
    [self removeFromSuperview];
}

- (IBAction)didClickCancelButton:(UIBarButtonItem *)sender {
    [self.delegate cancelSelectPickerView:self];
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark Getters and Setters

- (NSMutableDictionary *)contents {
    if (nil == _contents) {
        _contents = [[NSMutableDictionary alloc] init];
    }
    return _contents;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.picker selectRow:6 inComponent:0 animated:YES];
}


@end
