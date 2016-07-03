//
//  CommentsObj.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CommentsObj : NSObject
@property (assign, nonatomic) int Id;
@property (assign, nonatomic) int crowdFundId;
@property (assign, nonatomic) int commentUserId;
@property (assign, nonatomic) int replyUserId;
@property (assign, nonatomic) int statusId;
@property (copy, nonatomic) NSString *commentNickname;
@property (copy, nonatomic) NSString *commentAvatar;
@property (copy, nonatomic) NSString *replyNickname;
@property (copy, nonatomic) NSString *replyUsername;
@property (copy, nonatomic) NSString *commentMsg;
@property (copy, nonatomic) NSString *replyMsg;
@property (copy, nonatomic) NSString *modifyDate;
@property (copy, nonatomic) NSString *createDate;
@property (nonatomic,strong)NSString *commentUserName;
@property (nonatomic,strong)NSString *commentNotes;
@property (nonatomic,strong)NSString *replyNotes;
@end
