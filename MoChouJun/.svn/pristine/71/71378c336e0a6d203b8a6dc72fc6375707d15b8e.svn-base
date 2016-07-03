//
//  VersionUtil.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "VersionUtil.h"
#import "NetWorkingUtil.h"
@interface VersionUtil()<UIAlertViewDelegate>

@end
@implementation VersionUtil
+ (void)updateVersion:(void(^)(BOOL update ,BOOL isMandatory))callback
{
    [[NetWorkingUtil netWorkingUtil] requestDic4MethodName:@"SysConfig/AppVersion" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 ||status == 0)
        {
            BOOL luanch = [dic[@"launch"] integerValue];// 是否开启更新功
            BOOL  isMandatory = [dic[@"isMandatory"] integerValue];// 是否强制更新
            
            NSString  *versionStr = dic[@"version"];
            NSDictionary *info  = [NSBundle mainBundle].infoDictionary;
            NSString *infoVersion = info[@"CFBundleShortVersionString"];
            
            BOOL isUpdate = (luanch && ![versionStr isEqualToString:infoVersion]);
            callback(isUpdate,isMandatory);
        }
    }];
}

@end
