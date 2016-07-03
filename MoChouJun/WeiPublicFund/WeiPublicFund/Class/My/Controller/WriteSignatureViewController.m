//
//  WriteSignatureViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/11.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//
#define TEXT_MAXLENGTH           @"30"
#import "WriteSignatureViewController.h"

@interface WriteSignatureViewController ()<UITextViewDelegate>

@end

@implementation WriteSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBarButtomItemWithTitle:@"取消" target:self action:@selector(backClick) leftOrRight:YES];
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(commitOpinionBtnClick) leftOrRight:NO];
    
    _writeSignatureTextView.delegate = self;
    
    if (_signatureStr != nil) {
        _writePlacHoderLab.hidden = YES;
        _writeSignatureTextView.text = _signatureStr;
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_writeSignatureTextView.text.length > 30) {
        [MBProgressHUD showMessag:@"已经超过最大字数" toView:self.view];
        NSRange rgs = {0,TEXT_MAXLENGTH.intValue};
        NSString *s = [textView.text substringWithRange:rgs];
        [textView setText:[textView.text stringByReplacingOccurrencesOfString:textView.text withString:s]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = TEXT_MAXLENGTH.intValue -[new length];
    NSLog(@"%ld    %ld",(long)res,[text length]);
    if ([text length] > (TEXT_MAXLENGTH.intValue - textView.text.length)) {
        [MBProgressHUD showMessag:@"已经超过最大字数" toView:self.view];
        return NO;
    }else{
        if(res >= 0){
            return YES;
        }else{
            NSRange rg = {0,[text length]+res};
            NSLog(@"---%lu",[text length]+res);
            NSLog(@"==%lu",(unsigned long)rg.length);
            if (rg.length > 0) {
                NSRange rgs = {0,TEXT_MAXLENGTH.intValue};
                NSString *s = [textView.text substringWithRange:rgs];
                [textView setText:[textView.text stringByReplacingOccurrencesOfString:textView.text withString:s]];
                return NO;
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)commitOpinionBtnClick
{
    if (_writeSignatureTextView.text.length == 0) {
        [MBProgressHUD showMessag:@"您还没有填写个性签名哦" toView:self.view];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_writeSignatureTextView.text forKey:@"Info"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WriteSignature" object:nil userInfo:dic];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
