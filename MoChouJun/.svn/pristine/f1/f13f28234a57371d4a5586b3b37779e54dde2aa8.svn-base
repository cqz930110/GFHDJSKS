//
//  ExpressAddresseCell.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ExpressAddresseCell.h"
#import "Address.h"
@interface ExpressAddresseCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionDefaultButton;

@end
@implementation ExpressAddresseCell

- (void)setAddress:(Address *)address
{
    _address = address;
    _nameLabel.text = _address.recvName;
    _mobileLabel.text = _address.mobile;
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",_address.address,_address.details];
    if (_address.statusId == 2) {
        _optionDefaultButton.selected = 1;
    }else{
        _optionDefaultButton.selected = 0;
    }
}

- (IBAction)optionDefaultAddress:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(expressAddresseCellOptionDefaultAddress:)])
    {
        [self.delegate expressAddresseCellOptionDefaultAddress:self];
    }
}

@end
