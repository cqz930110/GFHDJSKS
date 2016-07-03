//
//  ProjectContentCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/30.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectContentCell.h"
#import "ProjectDetailsObj.h"
#import "NSString+Adding.h"
#import "EMCDDeviceManager.h"
#import "UIButton+WebCache.h"

@interface ProjectContentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIView *openStateView;
@property (weak, nonatomic) IBOutlet UIButton *openStateButton;
@property (assign, nonatomic) CGFloat cellMaxHeight;
@property (assign, nonatomic) BOOL recordPlaying;
@property (assign, nonatomic) BOOL open;
@property (copy,nonatomic) NSString *recordDuration;
@end
@implementation ProjectContentCell
static const CGFloat projectContentMargin = 10.0;
- (void)awakeFromNib {
    _recordPlaying = NO;
}

- (void)dealloc
{
    _recordPlaying = NO;
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}

#pragma mark - Setter & Getter
- (void)setOpen:(BOOL)open
{
    _open = open;
    
    CGFloat offsetTop;
    if (_open)
    {
        offsetTop = _cellMaxHeight - _openStateView.height;
        _contentLabel.hidden = NO;
        [_openStateButton setTitle:@"收起详情" forState:UIControlStateNormal];
        [_openStateButton setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    }
    else
    {
        offsetTop = CGRectGetMaxY(_detailLabel.frame) + projectContentMargin;
        _contentLabel.hidden = YES;
        [_openStateButton setTitle:@"查看全部详情" forState:UIControlStateNormal];
        [_openStateButton setImage:[UIImage imageNamed:@"arrow-1"] forState:UIControlStateNormal];
    }
    _openStateView.top = offsetTop;
    _projectDetail.currentCellHeight = CGRectGetMaxY(_openStateView.frame);
}

- (void)setProjectDetail:(ProjectDetailsObj *)projectDetail
{
    //========name=========
    _projectDetail = projectDetail;
    
    CGFloat height = projectContentMargin;
    _nameLabel.text = _projectDetail.name;
    _nameLabel.height = [_projectDetail nameTextHeight];
    height +=  _nameLabel.height; //name 高度
    //=========profile=========
    height += projectContentMargin;
    _detailLabel.text = _projectDetail.content;
    _detailLabel.top = height;
    _detailLabel.height = [_projectDetail profileTextHeight];
    height += _detailLabel.height;
    height += projectContentMargin;
    //======== 收起或 展开
    _openStateView.top = height;// 默认

    //===================== content ==============
    _contentLabel.text = _projectDetail.content;
    _contentLabel.top = height;
    _contentLabel.height = [_projectDetail contentTextHeight];
    height += _contentLabel.height;
    //=============录音========
    height += projectContentMargin;
    if (!IsStrEmpty(_projectDetail.filePath) || _projectDetail.filePath.length )
    {
        _recordView.top = height;
        height += _recordView.height;
        height += projectContentMargin;
        _recordView.hidden = NO;
        _recordTitleLabel.text = [NSString stringWithFormat:@"来自“%@”的声音",_projectDetail.nickName];
        [_recordButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_projectDetail.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"start_默认"]];
    }
    else
    {
        _recordView.hidden= YES;
    }
    
    _cellMaxHeight = height + _openStateView.height;
    self.open = _projectDetail.open;
}

#pragma mark - Action
- (IBAction)openStateChange
{
//    if (_projectDetail.htmlDescription.length > 0) {
//        NSLog(@"----------");
//    }else{
//        _projectDetail.open = !_projectDetail.open;
//        self.open = _projectDetail.open;
//    }
    
    if ([self.delegate respondsToSelector:@selector(projectContentCellOpenStateChanged:)])
    {
        [self.delegate projectContentCellOpenStateChanged:self];
    }
}

- (IBAction)recordAction
{
    if (_recordPlaying == NO)
    {
        NSString *filePath = _projectDetail.filePath;
        if (!IsStrEmpty(filePath))
        {
            self.recordPlaying = YES;
            [self playRecordWithPath:filePath];
        }
        else
        {
            NSLog(@"音频有问题");
        }
    }
    else
    {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
        self.recordPlaying = NO;
    }
}


- (void)setRecordPlaying:(BOOL)recordPlaying
{
    _recordPlaying = recordPlaying;
    _recordButton.selected = _recordPlaying;
}

#pragma mark - 录音
- (void)playRecordWithPath:(NSString *)path
{
    [[EMCDDeviceManager sharedInstance] enableProximitySensor];
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path playing:^(NSError *error, NSTimeInterval duraiton, NSTimeInterval currentTime) {
        if (error)
        {
            [MBProgressHUD showError:@"加载音频失败" toView:nil];
            self.recordPlaying = NO;
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
        else
        {
            if (!_recordDuration && duraiton > 0.0)
            {
                _recordDuration = [self mTimeformatFromSeconds:duraiton];
            }
            
            _recordTimeLabel.text = [NSString stringWithFormat:@"%@/%@",[self mTimeformatFromSeconds:currentTime],_recordDuration];
            if ((NSInteger)currentTime == (NSInteger)duraiton)
            {
                self.recordPlaying = NO;
                [[EMCDDeviceManager sharedInstance] disableProximitySensor];
            }
        }
    }];
}

- (NSString *)mTimeformatFromSeconds:(NSTimeInterval)seconds
{
    return [NSString stringWithFormat:@"%02zd:%02zd",(NSInteger)seconds/60,(NSInteger)seconds%60];
}

//播放语音
//- (void)playRecordWithPath:(NSString *)path
//{
//    [[EMCDDeviceManager sharedInstance] enableProximitySensor];
//    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
//        if (error)
//        {
//            [MBProgressHUD showError:@"加载音频失败" toView:nil];
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.recordPlaying = NO;
//                [[EMCDDeviceManager sharedInstance] disableProximitySensor];
//            });
//        }
//    }];
//}

@end
