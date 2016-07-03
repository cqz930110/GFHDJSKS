//
//  ProjectDetailsObj.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ProjectDetailsObj.h"
#import "NSString+Adding.h"
static const CGFloat kMargin = 10.0;
@implementation ProjectDetailsObj
- (void)setContent:(NSString *)content
{
    content = [content stringByReplacingOccurrencesOfString:@"###" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"|||" withString:@"\n"];

    NSArray *strs = [content componentsSeparatedByString:@"==="];
    
    NSMutableString *mustr = [NSMutableString string];
    
    for (NSString *str in strs)
    {
        NSString *newStr = [str stringByAppendingString:@"\n\n"];
        [mustr appendString:newStr];
    }
    if (_addContent.length)
    {
        [mustr appendString:[NSString stringWithFormat:@"\n%@",_addContent]];
    }
    _content = mustr;
}

//- (void)setShowStatus:(NSString *)showStatus
//{
//    if ([showStatus rangeOfString:@"剩余"].location != NSNotFound)
//    {
//        _showStatus = showStatus;
//    }
//    else
//    {
//        _showStatus = @"";
//    }
//}

- (CGFloat)nameTextHeight
{
    if (_nameTextHeight > 0.1) return _nameTextHeight;
    _nameTextHeight =  [_name sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 135, 40)].height;
    return _nameTextHeight;
}

- (CGFloat)profileTextHeight
{
    if (_profileTextHeight > 0.1) return _profileTextHeight;
    _profileTextHeight =  [_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, 60)].height;
    return _profileTextHeight;
}

- (CGFloat)contentTextHeight
{
    return [self.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, 9999)].height;
}

- (void)setProfile:(NSString *)profile
{
    _profile = profile;
    
    // 初始化未展开高度
    CGFloat height = kMargin;
    height +=  20; //name 高度
    height += kMargin;
    if (!IsStrEmpty(_profile)) {
        height += [self profileTextHeight];
    }
    height += kMargin;
    height += 30;
    _currentCellHeight = height;
}

- (void)setAudios:(NSString *)audios
{
    _audios = audios;

    // 写入文件
    if ([_audios rangeOfString:@"http"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_audios]];
            NSLog(@"%zd",audioData.length);
            NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            _filePath = [docDirPath stringByAppendingPathComponent:@"Audio.amr"];
            
            NSString *wavFilePath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:wavFilePath])
            {
                [fileManager removeItemAtPath:wavFilePath error:nil];
            }
            
            [audioData writeToFile:_filePath atomically:YES];
        });
    }
}

@end
