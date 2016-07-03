//
//  GroupNoticeCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupNotice;
@protocol GroupNoticeCellDelegate<NSObject>
- (void)changeGroupNotice:(GroupNotice *)groupNotice;
@end
@interface GroupNoticeCell : UITableViewCell
@property (weak, nonatomic) id<GroupNoticeCellDelegate> delegate;
@property (assign, nonatomic) BOOL canEdit;
@property (strong, nonatomic) GroupNotice *groupNotice;

+ (CGFloat)contentHeightWithContent:(NSString *)content canEdit:(BOOL)canEdit;
@end
