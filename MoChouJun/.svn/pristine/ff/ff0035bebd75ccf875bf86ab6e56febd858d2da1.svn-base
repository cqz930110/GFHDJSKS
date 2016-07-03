//
//  NSString+Adding.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "NSString+Adding.h"

@implementation NSString (Adding)
- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size{

    CGSize retSize = CGSizeZero;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {

        CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
        retSize.width = ceil(rect.size.width);
        retSize.height = ceil(rect.size.height);

    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        retSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return retSize;
}

- (NSString *)strmethodComma
{
    NSString *string = self;
    if (string.length <= 3) {
        return string;
    }
    
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    
    NSArray *signs = [string componentsSeparatedByString:@"."];
    string = signs[0];
    //    NSLog(@"====%lu",(unsigned long)string.length);
    if (string.length <= 3 && signs.count == 2) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
        return string;
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    NSInteger commaNum = ([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        NSInteger index = [pointFront length] - (i+1)*3;
        NSInteger leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        
        [arr2 addObject:arr[i]];
    }
    [arr2 addObject:pointLast];
    NSString *commaString = [arr2 componentsJoinedByString:@","];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    if (signs.count == 2) {
        commaString = [commaString stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
    }
    return commaString;
}

- (NSString *)wanStrmethodComma
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat value = [str floatValue];
    CGFloat wanValue = value/10000;
    str = [NSString stringWithFormat:@"%f",wanValue];
    str = [str strmethodComma];
    NSRange range = [str rangeOfString:@"."];
    
    if (range.location != NSNotFound)
    {
        NSArray *strs = [str componentsSeparatedByString:@"."];
        NSUInteger index = -1;
        if (strs.count>=2)
        {
            str = strs[1];
            if ([str hasSuffix:@"0"])
            {
                
                for (int i = 0;i<str.length ; i++)
                {
                    NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
                    if ([subString integerValue] != 0)
                    {
                        index = i;
                    }
                }
            }
        }
        
        if (index == -1)
        {
            str = strs[0];
        }
        else
        {
            if (index == str.length - 1)
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],str];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],[str substringWithRange:NSMakeRange(0, index + 1)]];
            }
        }
    }
    return str;
}

- (NSString *)base64encode:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64decode:(NSString *)str
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByRemoveWhiteSpaceInString
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)stringByRemoveWhiteSpaceAndNewLine
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}

- (NSString *)stringByRemoveWhiteSpaceAndNewLineFromPreFixSuffix
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

+ (NSString*)stringJSONSerializationFromDic:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//URLEncode
+ (NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
//  H5特殊字符判断
+ (NSString *)stringReplaceStr:(NSString *)str
{
    NSString *contentStr = nil;
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        contentStr = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
    
    return contentStr;
}

+ (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

@end
