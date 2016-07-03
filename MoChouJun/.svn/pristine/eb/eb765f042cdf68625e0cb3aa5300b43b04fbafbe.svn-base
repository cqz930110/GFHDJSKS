//
//  NSString+DocumentPath.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/18.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)
+(NSString *)documentPathWith:(NSString *)fileName
{
    NSString *doucmentPath=    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Record"];
    
    //创建目的路径的文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:doucmentPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [doucmentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}
@end
