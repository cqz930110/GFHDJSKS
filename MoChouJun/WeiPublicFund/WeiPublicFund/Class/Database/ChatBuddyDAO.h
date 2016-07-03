//
//  ChatBuddyDAO.h
//  fmdb
//
//  Created by Apple on 16/4/2.
//
//  用于缓存用户头像

#import "DAO.h"
@class PSChat;
@interface ChatBuddyDAO : DAO
// ============增加/改============
+ (BOOL)updateChatBuddy:(PSChat *)chatBuddy;
// =============查============
+ (PSChat *)chatBuddyWithUserame:(NSString *)username;
+ (NSString *)avatarWithUserame:(NSString *)username;
+ (NSString *)nicknameWithUserame:(NSString *)username;
+ (NSDictionary *)userInfoWithUserame:(NSString *)username;

// ===========删除==============
+ (BOOL)deleteChatBuddys:(NSArray *)chatBuddys;
+ (BOOL)deletChatBuddy:(PSChat *)chatBuddy;
@end
