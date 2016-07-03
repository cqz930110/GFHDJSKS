//
//  SupportMyProjectTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportMyProjectTableViewCell.h"
#import "NetWorkingUtil.h"
#import <UIButton+WebCache.h>
#import "SupportedProject.h"
@implementation SupportMyProjectTableViewCell

- (void)awakeFromNib
{
    _supportPeopleBtn.layer.cornerRadius = 20.0f;
    _supportPeopleBtn.layer.masksToBounds = YES;
}

- (void)setSupportMyProject:(SupportedProject *)supportMyProject
{
    _supportMyProject = supportMyProject;
    [_supportPeopleBtn sd_setImageWithURL:[NSURL URLWithString:_supportMyProject.userAvatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    _supportPeopleName.text =_supportMyProject.userNickname;
    _supportPeopleAmountLab.text = [NSString stringWithFormat:@"%.2f",_supportMyProject.amount];
    _supportPeopleDataLab.text = _supportMyProject.createDate;
}

- (IBAction)headerIconAction
{
    if ([self.delegate respondsToSelector:@selector(supportProjectCellDidClikeIcon:)])
    {
        [self.delegate supportProjectCellDidClikeIcon:self];
    }
}

@end
