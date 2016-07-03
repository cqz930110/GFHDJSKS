//
//  AudioView.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/16.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioView : UIView
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIImageView *audioRecoderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audioRecoderImageView1;
@property (weak, nonatomic) IBOutlet UILabel *showTimeLab;

@end
