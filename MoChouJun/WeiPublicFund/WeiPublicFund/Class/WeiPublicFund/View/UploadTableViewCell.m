//
//  UploadTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "UploadTableViewCell.h"
#import "StartProjectViewController.h"

@implementation UploadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)uploadImageClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadImageTableViewCell:supportProject:)]) {
        [self.delegate uploadImageTableViewCell:self supportProject:nil];
    }
}
- (IBAction)uploadAudioClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(uploadAudioTableViewCell:supportProject:)]) {
        [self.delegate uploadAudioTableViewCell:self supportProject:nil];
    }
}

- (void)setShowState:(BOOL)showState
{
    if (showState == YES) {
        _startImageView.hidden = NO;
        _startLab.hidden = NO;
    }else{
        _startImageView.hidden = YES;
        _startLab.hidden = YES;
    }
}

- (void)setShowAudioState:(BOOL)showAudioState
{
    if (showAudioState == YES) {
        _audioImageView.hidden = NO;
        _audioLab.hidden = NO;
        _showTimeLab.hidden = YES;
    }else{
        _audioImageView.hidden = YES;
        _audioLab.hidden = YES;
        _showTimeLab.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
