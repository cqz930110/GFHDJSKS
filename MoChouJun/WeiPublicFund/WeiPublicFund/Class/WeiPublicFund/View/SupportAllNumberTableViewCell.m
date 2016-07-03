//
//  SupportAllNumberTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SupportAllNumberTableViewCell.h"
#import "SupportReturn.h"
@implementation SupportAllNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSupportReturn:(SupportReturn *)supportReturn
{
    _supportReturn = supportReturn;
    
    if (_supportReturn.maxNumber == 0) {
        _supleNumberLab.text = [NSString stringWithFormat:@"不限制数量"];
    }else{
        _supleNumberLab.text = [NSString stringWithFormat:@"还剩%zd件",(_supportReturn.maxNumber - _supportReturn.supportCount)];
    }
    
    
    [self setTotalAmountLabText:[NSString stringWithFormat:@"支持金额：¥%.2f",_supportReturn.supportAmount]];
}

- (void)setTotalAmountLabText:(NSString *)str
{
    NSMutableAttributedString * atriAmountText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    [atriAmountText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#181818"] range:NSMakeRange(0, 5)];
    [atriAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(6, atriAmountText.length - 9)];
    _supportAmountLab.attributedText = atriAmountText;
}

- (void)setShowType:(BOOL)showType
{
    _showType = showType;
    if (_showType) {
        _supportAmountLab.hidden = YES;
        _supportAmountTextField.hidden = NO;
        _showLab.hidden = NO;
    }else{
        _supportAmountLab.hidden = NO;
        _supportAmountTextField.hidden = YES;
        _showLab.hidden = YES;
    }
}
//   减
- (IBAction)reduceBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changeBtnClick:returnType:returnCell:)]) {
        [self.delegate changeBtnClick:_supportReturn returnType:0 returnCell:self];
    }
}
//  加
- (IBAction)addBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(changeBtnClick:returnType:returnCell:)]) {
        [self.delegate changeBtnClick:_supportReturn returnType:1 returnCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
