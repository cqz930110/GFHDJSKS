//
//  WeiSponsortTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "WeiSponsortTableViewCell.h"
#import "TLAttributedLabel.h"
#import "ProjectDetailsObj.h"

@interface WeiSponsortTableViewCell () <TLAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *projectProfileLab;
@end

@implementation WeiSponsortTableViewCell

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

- (void)awakeFromNib {
    self.contentLab.frame = CGRectMake(15, 125, SCREEN_WIDTH - 30, 0);
    [self.contentView addSubview:self.contentLab];
}

- (void)setModel:(ProjectDetailsObj *)model {
    _model = model;
    _projectNameLab.text = _model.name;
    _projectProfileLab.text = _model.profile;
    [_contentLab setText:model.content];
    _contentLab.state = model.state;
    _contentLab.numberOfLines = model.numberOfLines;
    CGSize size = [_contentLab sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kMargin, MAXFLOAT)];
    if (SCREEN_WIDTH != 320) {
        size.height = size.height + 20;
    }
    CGFloat y = 125;
    if (_model.nickName)
    {
        y += 25;
    }
    
    _contentLab.frame = CGRectMake(15,y, SCREEN_WIDTH - 30, size.height + 5);
    if (IsStrEmpty(_model.audios)) {
        [self updataHeight:size.height];
    }
}

// 改变Y值
- (void)updataHeight:(CGFloat)height
{
    _contentLab.top = 77 + 15;
}

#pragma mark - Setter
- (TLAttributedLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[TLAttributedLabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
        _contentLab.delegate = self;
        _contentLab.backgroundColor = [UIColor clearColor];
        [_contentLab setOpenString:@"［查看更多］" closeString:@"［点击收起］" font:[UIFont systemFontOfSize:13] textColor:[UIColor blueColor]];
    }
    return _contentLab;
}

- (void)setHideState:(BOOL)hideState
{
    if (hideState == YES) {
        _playVideoBtn.hidden = YES;
        _playStateImageView.hidden = YES;
        _playFromLab.hidden = YES;
    }else{
        _playVideoBtn.hidden = NO;
        _playStateImageView.hidden = NO;
        _playFromLab.hidden = NO;
        _playVideoBtn.layer.borderWidth = 1.0f;
        _playVideoBtn.layer.borderColor = [UIColor greenColor].CGColor;
        _playVideoBtn.layer.cornerRadius = 5.0f;
        _playFromLab.text = [NSString stringWithFormat:@"来自: %@",_model.nickName];
    }
}

#pragma mark - TLAttributedLabelDelegate
- (void)displayView:(TLAttributedLabel *)label openHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:0];
    }
}

- (void)displayView:(TLAttributedLabel *)label closeHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:numberOfLines];
    }
}
@end
