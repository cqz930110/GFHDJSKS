//
//  PSBankCardTextField.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/2/24.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "PSBankCardTextField.h"

@implementation PSBankCardTextField

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //添加 textFieldEditDidChange 通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChanged:(NSNotification *)noti
{
    // 1234 5678 3455 2342 2344  2342
    NSUInteger textLength = self.text.length;
    
    if (textLength%5 == 0 && textLength >= 5)
    {
        if ([self.text hasSuffix:@" "])
        {
            //删除空格
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(textLength - 1, 1) withString:@""];
        }
        else
        {
            // 增加空格
            NSMutableString *bankStyleText = [self.text mutableCopy];
            NSUInteger index = textLength - 1;
            [bankStyleText insertString:@" " atIndex:index];
            self.text = bankStyleText;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
