//
//  NdUncaughtExceptionHandler.m
//  SuningEBuy
//
//  Created by xy ma on 12-1-4.
//  Copyright (c) 2012年 sn. All rights reserved.
//

#import "NdUncaughtExceptionHandler.h"
#import "NetWorkingUtil.h"
static inline NSString  *applicationDocumentsDirectory() {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    DLog(@"application document path is = %@\n",path);
    return path;
    
}
//static inline
void  static UncaughtExceptionHandler(NSException *exception) {
    
    NSArray *arr = [exception callStackSymbols];
    
    NSString *reason = [exception reason];
    
    NSString *name = [exception name];
    
    
    
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     
                     name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"CashLog.txt"];
    
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    
    //或者调用某个处理程序来处理这个信息
    
//    NSString *urlStr = [NSString stringWithFormat:@"mailto://persenzhou@126.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
//                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@", 
//                        name,reason,[arr componentsJoinedByString:@"<br>"]];
//    NSURL *url2 = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url2];
    
//    NSString *crashInfo = [NSString stringWithFormat:@"name:_, reason:_, ncallStackSymbols:_"];
    
//    [[NetWorkingUtil netWorkingUtil] requestDic4MethodName:@"SysConfig/BugTrack" parameters:@{@"msg":crashInfo} result:^(NSDictionary *dic, int status, NSString *msg) {
//    }];    
}

@implementation NdUncaughtExceptionHandler
-(NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"CashLog.txt"];
    NSString *crashText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (crashText.length > 0)
    {
        [[NetWorkingUtil netWorkingUtil] requestDic4MethodName:@"SysConfig/BugTrack" parameters:@{@"Msg":crashText} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status ==2 )
            {
                [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        }];
    }
}

+ (NSUncaughtExceptionHandler*)getHandler

{
    return NSGetUncaughtExceptionHandler();
}
@end
