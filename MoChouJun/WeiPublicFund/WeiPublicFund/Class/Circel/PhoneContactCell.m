//
//  PhoneContactCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/15.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "PhoneContactCell.h"
//#import "AppDelegate.h"
#import "AddressBookManage.h"
@interface PhoneContactCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end
@implementation PhoneContactCell



- (void)awakeFromNib
{
    _headerImage.layer.cornerRadius = 35*0.5;
    _headerImage.layer.masksToBounds = YES;
}

- (void)setContact:(Contact *)contact
{
    _contact = contact;
    NSInteger stautsId = [_contact.statusId integerValue];
    _addButton.hidden = !stautsId;
    _inviteButton.hidden = stautsId;
    
    [[AddressBookManage addressBookManage].addressBook loadPhotoByRecordID:_contact.contentId completion:^(UIImage *image)
    {
        if(image)
        {
            _headerImage.image = image;
        }
        else
        {
            _headerImage.image = [UIImage imageNamed:@"home_默认"];
        }
    }];
    
    _nameLabel.text = _contact.name;
    _phoneNumLabel.text = _contact.phone;
    
}

- (IBAction)clickAction:(UIButton *)sender
{
//    _inviteButton.hidden = _addButton.hidden;
    if (sender.tag)
    {
        // 添加操作
        if ([self.delegate respondsToSelector:@selector(phoneContactCellAdd:)]) {
            [self.delegate phoneContactCellAdd:self];
        }
    }
    else
    {
        // 邀请操作
        if ([self.delegate respondsToSelector:@selector(phoneContactCellInvite:)]) {
            [self.delegate phoneContactCellInvite:self];
        }
    }
}

@end
