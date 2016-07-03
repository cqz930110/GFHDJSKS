//
//  ConversationHeaderCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConversationHeaderCell;
typedef NS_ENUM(NSInteger,ConversationHeaderOptionType)
{
    ConversationHeaderOptionTypeContacts,
    ConversationHeaderOptionTypeProjectGroup,
    ConversationHeaderOptionTypeSystemNotification
};

@protocol ConversationHeaderCellDelegate<NSObject>
- (void)optionHeaderCell:(ConversationHeaderCell *)cell optionType:(ConversationHeaderOptionType)optionType;
@end
@interface ConversationHeaderCell : UITableViewCell
@property (weak, nonatomic) id<ConversationHeaderCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *systemMessageUnreadLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactUnReadLabel;
@end
