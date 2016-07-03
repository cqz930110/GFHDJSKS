//
//  SupportPeopleTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportPeopleTableViewCell.h"
#import "SupportPeople.h"
#import "NetWorkingUtil.h"
#import "UIButton+EMWebCache.h"

@interface SupportPeopleTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation SupportPeopleTableViewCell

- (void)awakeFromNib {
    _supportIconBtn.layer.cornerRadius = 17.5f;
    _supportIconBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSupportPeople:(SupportPeople *)supportPeople
{
    _supportPeople = supportPeople;

    [_supportIconBtn sd_setImageWithURL:[NSURL URLWithString:_supportPeople.userAvatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    _nameLabel.text = _supportPeople.userNickname;
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",_supportPeople.amount];
    _timeLabel.text = _supportPeople.createDate;
    
}

- (void)setSupportCountDic:(NSDictionary *)supportCountDic
{
    _supportCountDic = supportCountDic;
    
    [_supportIconBtn sd_setImageWithURL:[NSURL URLWithString:[_supportCountDic objectForKey:@"Avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    _nameLabel.text = IsStrEmpty([_supportCountDic objectForKey:@"NickName"])?[_supportCountDic objectForKey:@"UserName"]:[_supportCountDic objectForKey:@"NickName"];
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %@",[_supportCountDic objectForKey:@"SupportAmount"]];
    _timeLabel.text = [_supportCountDic objectForKey:@"SupportTime"];
}

@end
