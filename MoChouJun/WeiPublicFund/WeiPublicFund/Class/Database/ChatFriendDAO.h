//
//  ChatFriend.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/4/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "DAO.h"
@class PSBuddy;
@interface ChatFriendDAO : DAO
// ============增加/改============
+ (void)updateChatFriends:(NSArray *)chatFriends;
+ (BOOL)updateChatFriend:(PSBuddy *)chatFriend;

// =============查============
+ (NSArray *)allChatFriends;
+ (PSBuddy *)chatFriendWithUserame:(NSString *)username;
+ (NSString *)avatarWithUserame:(NSString *)username;
+ (NSString *)nicknameWithUserame:(NSString *)username;
+ (NSDictionary *)userInfoWithUserame:(NSString *)username;
+ (BOOL)existChatFriendWithUsername:(NSString *)username;

// ===========删除==============
+ (BOOL)deleteChatFriends:(NSArray *)usernames;
+ (BOOL)deletChatFriendWithUsername:(NSString *)username;
@end
