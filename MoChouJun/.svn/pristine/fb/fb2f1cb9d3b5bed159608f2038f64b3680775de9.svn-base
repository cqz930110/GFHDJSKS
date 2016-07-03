//
//  GroupNoticeCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "GroupNoticeCell.h"
#import "GroupNotice.h"
#import "NSString+Adding.h"
@interface GroupNoticeCell()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation GroupNoticeCell
+ (CGFloat)contentHeightWithContent:(NSString *)content canEdit:(BOOL)canEdit
{
    CGFloat height = 73;
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, 999)];
    height += contentSize.height;
    if (canEdit)
    {
        height += 25;
        height += 3;
    }
    return height;
}

- (void)setGroupNotice:(GroupNotice *)groupNotice
{
    _groupNotice = groupNotice;
    _noticeName.text = _groupNotice.title;
    _nameLabel.text = _groupNotice.author;
    _contentLabel.text = _groupNotice.content;
    _timeLabel.text = _groupNotice.modifyDate;
//    _contentLabel.backgroundColor = [UIColor redColor];
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    _editButton.hidden = !_canEdit;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = _contentLabel.frame;
    CGSize contentSize = [_groupNotice.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, 999)];
    contentRect.size.height = contentSize.height;

    _contentLabel.frame = contentRect;
    if (_canEdit)
    {
        _editButton.top = CGRectGetMaxY(_contentLabel.frame);
    }
}

#pragma mark - Actions
- (IBAction)changeNoticeAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(changeGroupNotice:)])
    {
        [self.delegate changeGroupNotice:_groupNotice];
    }
}

@end
