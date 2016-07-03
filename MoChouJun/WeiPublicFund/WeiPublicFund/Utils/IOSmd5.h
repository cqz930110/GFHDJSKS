//
//  IOSmd5.h
//  JYB
//
//  Created by test on 14-9-6.
//  Copyright (c) 2014年 MyProduct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSmd5 : NSObject

+(NSString *) md5: (NSString *) inPutText ;

+(NSString *) md5Big: (NSString *) inPutText; // 返回大写字母
@end
