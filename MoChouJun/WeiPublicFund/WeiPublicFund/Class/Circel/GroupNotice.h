//
//  GroupNotice.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/17.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNotice : NSObject
/// 公告ID
@property (assign, nonatomic) long Id;
/// 群ID
@property (assign, nonatomic) long groupId;

/// 公告标题
@property (copy, nonatomic) NSString *title;

/// 公告内容
@property (copy, nonatomic) NSString *content;

/// 修改日期
@property (copy, nonatomic) NSString *modifyDate;

/// 作者
@property (copy, nonatomic) NSString *author;
@end
