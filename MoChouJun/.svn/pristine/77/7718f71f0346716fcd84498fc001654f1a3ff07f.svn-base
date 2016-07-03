//
//  CommentsTableViewCell.h
//  TipCtrl
//
//  Created by liuyong on 15/11/30.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsTableViewCell;
@class CommentsObj;
@protocol CommentsTableViewCellDelegate <NSObject>

- (void)commentsTableViewCellReply:(CommentsTableViewCell *)cell replyModel:(CommentsObj *)model;
- (void)commentsTableViewCellClikeIcon:(CommentsTableViewCell *)cell replyModel:(CommentsObj *)model;
@end

@interface CommentsTableViewCell : UITableViewCell
@property (nonatomic, weak) id<CommentsTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL canReply;
- (void)setData:(CommentsObj *)data;
@end
