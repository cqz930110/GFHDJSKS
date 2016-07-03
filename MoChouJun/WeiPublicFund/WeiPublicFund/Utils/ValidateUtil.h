//
//  ValidateUtil.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/15.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateUtil : NSObject
//检验手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)validateBankCardNo:(NSString *)bankCardNo;

+ (NSInteger)characterCountOfString:(NSString *)string;

+ (NSInteger)characterCharCountOfString:(NSString *)string;

+ (BOOL)isValidateUserNameOrPassword:(NSString *)text;
@end
