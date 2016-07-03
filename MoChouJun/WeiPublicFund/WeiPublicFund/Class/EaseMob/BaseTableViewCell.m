/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "BaseTableViewCell.h"

#import "UIImageView+HeadImage.h"
#import "PSBuddy.h"
#import "NetWorkingUtil.h"
#import "PSGroup.h"
#import "BlackBuddy.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [self.contentView addSubview:_bottomLineView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
//        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
//        [self addGestureRecognizer:_headerLongPress];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 8, 34, 34);
    self.imageView.layer.cornerRadius = self.imageView.width * 0.5;
    self.imageView.layer.masksToBounds = YES;
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = rect;
    
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, SCREEN_WIDTH, 1);
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    [self.textLabel setTextWithUsername:_username];
    [self.imageView imageWithUsername:_username placeholderImage:self.imageView.image];
}

- (void)setBlackBuddy:(BlackBuddy *)blackBuddy
{
    _blackBuddy = blackBuddy;
    [self.textLabel setTextWithUsername:_blackBuddy.reviewName];
    [NetWorkingUtil setImage:self.imageView url:_blackBuddy.avatar defaultIconName:@"home_默认"];
}

- (void)setGroup:(PSGroup *)group
{
    _group = group;
    [self.textLabel setTextWithUsername:_group.groupName];
//    NSString *url = [NSString stringWithFormat:@"%@!200",_group.avatar];
//    NSLog(@"%@",url);
    [NetWorkingUtil setImage:self.imageView url:_group.avatar defaultIconName:@"home_默认"];
}

- (void)setBuddy:(PSBuddy *)buddy
{
    _buddy = buddy;
    [self.textLabel setTextWithUsername:_buddy.reviewName];
    [NetWorkingUtil setImage:self.imageView url:_buddy.avatar defaultIconName:@"home_默认"];
//    [self.imageView imageWithUsername:_username placeholderImage:self.imageView.image];
}

@end
