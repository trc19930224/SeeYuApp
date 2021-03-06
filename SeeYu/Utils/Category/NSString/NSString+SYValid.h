//
//  NSString+SYValid.h
//  SYDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SYValid)

/// 检测字符串是否包含中文
+( BOOL)sy_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)sy_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)sy_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)sy_isValidMobile:(NSString *)str;

/// 纯数字
+ (BOOL)sy_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)sy_isValidCharacterOrNumber:(NSString *)str;

/// 判断字符串全是空格or空
+ (BOOL) sy_isEmpty:(NSString *) str;

/// 是否是正确的邮箱
+ (BOOL) sy_isValidEmail:(NSString *)email;

/// 是否是正确的QQ
+ (BOOL) sy_isValidQQ:(NSString *)QQ;

/// 是否是正确的身份证号码
+ (BOOL)sy_validateIDCardNumber:(NSString *)value;

@end
