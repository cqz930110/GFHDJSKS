//
//  RequestAddressUtil.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/1/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBookManage.h"
#define kLoadContactTime @"kLoadContactTime"

//typedef void(^CompleteHandle)(int status,NSError *error,NSString *msg);
typedef NS_ENUM(NSInteger,RequestAddressStatus)
{
    RequestAddressStatusNoUpdate = 0,
    RequestAddressStatusUpdating,
    RequestAddressStatusUpdated,
    RequestAddressStatusUpdateFail
};
@interface RequestAddressUtil : NSObject
@property (assign, nonatomic) RequestAddressStatus updateStatus;
@property (copy, nonatomic) CompleteHandle complete;
+ (RequestAddressUtil *)shareRequestAddressUtil;

/**
 * 更新通讯录
 *
 *  @param complete  回调 status －1请求失败 0 不可以访问通讯录 1 成功
 */
- (void)updateAddressBookComplete:(CompleteHandle)complete;
@end
