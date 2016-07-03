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

#import "DAO.h"
typedef  NS_ENUM(NSInteger,ApplyState) {
    ApplyStateAcceptApplying = 0,//申请中
    ApplyStateReject,// 拒绝
    ApplyStateAccept//同意
    
};
@class ApplyEntity;
@interface InvitationManager : DAO

+ (BOOL)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

+ (BOOL)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

+ (BOOL)removeInvitationBuddyName:(NSString *)buddyName loginUser:(NSString *)username;

+ (NSArray *)applyEmtitiesWithloginUser:(NSString *)username;
@end

@interface ApplyEntity : NSObject 
@property (nonatomic, copy) NSString * applicantUsername;
@property (nonatomic, copy) NSString * applicantNick;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * receiverUsername;
@property (nonatomic, copy) NSString * receiverNick;
@property (nonatomic, copy) NSNumber * style;
@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, copy) NSString * groupSubject;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, strong) NSNumber * applyState;
@end
