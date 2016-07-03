//
//  AccountManageTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankCard;
@interface AccountManageTableViewCell : UITableViewCell
{
    NSDictionary *_accountDic;
}
@property (nonatomic,strong)BankCard *bankCard;
@property (weak, nonatomic) IBOutlet UIImageView *accountManageImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountManageNameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountManageNumberLab;

@end
