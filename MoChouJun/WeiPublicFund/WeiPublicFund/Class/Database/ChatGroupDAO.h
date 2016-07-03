//
//  ChatGroup.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "DAO.h"
@class PSGroup;
@interface ChatGroupDAO : DAO

// ============增加/改============
+ (BOOL)updateChatGroup:(PSGroup *)chatGroup;

// =============查============
///群类型 0聊天群 1项目群
+ (NSArray *)chatGroupsWithGroupType:(NSInteger)groupType;

+ (PSGroup *)chatGroupWithGroupId:(long)groupId;
+ (NSString *)avatarWithGroupId:(long )groupId;
+ (NSString *)groupNameWithGroupId:(long )groupId;
+ (NSDictionary *)userInfoWithGroupId:(long )groupId;

// ===========删除==============
+ (BOOL)deleteChatGroups:(NSArray *)chatGroups;
+ (BOOL)deletChatGroup:(PSGroup *)chatGroup;
@end
