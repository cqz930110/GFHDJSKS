//
//  CommentReturnedCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/10.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsObj;
@class CommentReturnedCell;
@protocol CommentReturnedCellDelegate <NSObject>
- (void)commentReturnedCellClikeIcon:(CommentReturnedCell *)cell comment:(CommentsObj *)comment;
@end

@interface CommentReturnedCell : UITableViewCell
@property (nonatomic, weak) id<CommentReturnedCellDelegate> delegate;
- (void)setData:(CommentsObj *)data;
@end
