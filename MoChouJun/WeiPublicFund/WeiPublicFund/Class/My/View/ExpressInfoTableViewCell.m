//
//  ExpressInfoTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ExpressInfoTableViewCell.h"
#import "ExpressObj.h"

@implementation ExpressInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setType:(NSString *)type
{
    _type = type;
}

- (void)setExpressObj:(ExpressObj *)expressObj
{
    _expressObj = expressObj;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@.00",_expressObj.supportAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _expressMoneyLab.attributedText = atriText;
  
    _expressContentLab.text = [NSString stringWithFormat:@"回报介绍：%@",_expressObj.Description];
//    _expressNickNameLab.text = [NSString stringWithFormat:@"昵称：%@",_expressObj.]
    _expressNumberDataLab.text = [NSString stringWithFormat:@"数量：%d件 %@",_expressObj.count,_expressObj.createDate];
    _expressRealNameLab.text = [NSString stringWithFormat:@"收件人：%@",_expressObj.recvName];
    _expressPhoneLab.text = [NSString stringWithFormat:@"电话：%@",_expressObj.mobile];
    _expressAddressLab.text = [NSString stringWithFormat:@"收件地址：%@",_expressObj.addressInfo];
    
    if ([_type isEqual:@"support"]) {
        _expressCommitBtn.hidden = YES;
        _expressCodeLab.hidden = YES;
    }else{
        _expressCommitBtn.hidden = NO;
        _expressCodeLab.hidden = NO;
        _expressCodeLab.text = [NSString stringWithFormat:@"%@  %@",_expressObj.expressName,_expressObj.expressNo];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
