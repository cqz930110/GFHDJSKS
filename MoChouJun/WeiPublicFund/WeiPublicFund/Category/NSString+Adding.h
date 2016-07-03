//
//  NSString+Adding.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Adding)

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;
//- (NSString *)moneyString;
- (NSString *)strmethodComma;
- (NSString *)wanStrmethodComma;

- (NSString *)stringByRemoveWhiteSpaceInString;
- (NSString *)stringByRemoveWhiteSpaceAndNewLine;
- (NSString *)stringByRemoveWhiteSpaceAndNewLineFromPreFixSuffix;
+ (NSString*)stringJSONSerializationFromDic:(NSDictionary *)dic;

// encode、decode编码
+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;

//  H5特殊字符判断
+ (NSString *)stringReplaceStr:(NSString *)str;

//  判断字符个数
+ (int)convertToInt:(NSString *)strtemp;
@end
