//
//  SystemNotificationCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SystemNotificationCell.h"
#import "SystemMessage.h"
#import "NSString+Adding.h"
@interface SystemNotificationCell()//12  60  17
@property (weak, nonatomic) IBOutlet UILabel *messageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation SystemNotificationCell

- (void)setMessage:(SystemMessage *)message
{
    _message = message;
    _messageContentLabel.text = _message.message; //43
    _timeLabel.text = _message.createDate;
    CGFloat contentHeight =  [_message.message  sizeWithFont:[UIFont systemFontOfSize:12] constrainedSize:CGSizeMake(SCREEN_WIDTH - 23, 999)].height;
    _messageContentLabel.height = contentHeight;
}

+ (CGFloat)contentHeightContentString:(NSString *)message
{
    CGFloat contentHeight =  [message  sizeWithFont:[UIFont systemFontOfSize:12] constrainedSize:CGSizeMake(SCREEN_WIDTH - 23, 999)].height;
    CGFloat height = 0.0;
    if (contentHeight > 17)
    {
        height = 60 - 17 + contentHeight;
    }
    else
    {
        height = 60;
    }
    return height;
}
@end
