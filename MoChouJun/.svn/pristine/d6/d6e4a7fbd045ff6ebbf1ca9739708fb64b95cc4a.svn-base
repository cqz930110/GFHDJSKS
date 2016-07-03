//
//  AccountManageTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AccountManageTableViewCell.h"
#import "NetWorkingUtil.h"
#import "BankCard.h"
@implementation AccountManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBankCard:(BankCard *)bankCard
{
    _bankCard = bankCard;
    NSLog(@"------%@",_bankCard.bankIconUrl);
    [_accountManageImageView sd_setImageWithURL:[NSURL URLWithString:_bankCard.bankIconUrl] placeholderImage:[UIImage imageNamed:@"select_bankcard"]];
    _accountManageNameLab.text = _bankCard.bankName;
    _accountManageNumberLab.text = _bankCard.transformAccountNum;
}

@end
