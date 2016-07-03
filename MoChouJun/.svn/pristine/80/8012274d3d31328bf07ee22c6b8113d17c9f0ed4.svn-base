//
//  ValidateUtil.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/15.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ValidateUtil.h"
#import "NetWorkingUtil.h"

@implementation ValidateUtil
//银行卡判断
+ (BOOL)validateBankCardNo:(NSString *)bankCardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[bankCardNo length];
    int lastNum = [[bankCardNo substringFromIndex:cardNoLength-1] intValue];
    
    bankCardNo = [bankCardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [bankCardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
}

+ (NSInteger)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0)
    {
        return 0;
    }
    for (int i = 0; i<string.length; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (isdigit(c)) {
            characterCount++;//数字
        }
    }
    return characterCount;
}

+ (NSInteger)characterCharCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0)
    {
        return 0;
    }
    for (int i = 0; i<string.length; i++)
    {
        unichar c = [string characterAtIndex:i];
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
        {
            characterCount++;//字母
        }
    }
    return characterCount;
}

+ (BOOL)isValidateUserNameOrPassword:(NSString *)text
{
//    NSString *regex = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{6,16}$";   //以A开头，e结尾
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regextestct evaluateWithObject:text];
}

@end
