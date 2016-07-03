//
//  CommentsTableViewCell.m
//  TipCtrl
//
//  Created by liuyong on 15/11/30.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "CommentsObj.h"
#import "NetWorkingUtil.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "NSString+Adding.h"
#import "User.h"
#import "UIButton+WebCache.h"

@interface CommentsTableViewCell ()
@property (strong, nonatomic) CommentsObj*data;
@property (weak, nonatomic) IBOutlet UILabel *commentUserNameLab;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLab;
@property (weak, nonatomic) IBOutlet UIButton *commentIconBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation CommentsTableViewCell
- (void)awakeFromNib
{
    _commentIconBtn.layer.cornerRadius = 17.5f;
    _commentIconBtn.layer.masksToBounds = YES;
//    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setData:(CommentsObj *)data
{
    _data = data;
    [_commentIconBtn sd_setImageWithURL:[NSURL URLWithString:_data.commentAvatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    _commentUserNameLab.text = data.commentNickname;
    _commentTimeLab.text = data.createDate;
    _commentContentLab.text = [NSString decodeString:data.commentMsg];
}

- (void)setCanReply:(BOOL)canReply
{
    _canReply = canReply;
    _replyButton.hidden = !_canReply;
}

- (IBAction)replyClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commentsTableViewCellReply:replyModel:)])
    {
        [self.delegate commentsTableViewCellReply:self replyModel:_data];
    }
}

- (IBAction)iconClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commentsTableViewCellClikeIcon:replyModel:)])
    {
        [self.delegate commentsTableViewCellClikeIcon:self replyModel:_data];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    //上分割线，
    
    //CGContextSetStrokeColorWithColor(context, COLORWHITE.CGColor);
    
    //CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithHexString:@"#EFEFF4"].CGColor);
    
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height, rect.size.width,1));
    
}

@end
