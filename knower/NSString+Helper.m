//
//  NSString+Helper.m
//  Hospital
//
//  Created by ios on 15/4/3.
//  Copyright (c) 2015年 ios. All rights reserved.
//

/**
 *
 * 常用正则表达式
 * [\u4e00-\u9fa5]	匹配中文字符
 * [^\x00-\xff]	匹配双字节字符(包括汉字在内)
 * \n\s*\r	匹配空白行
 * <(\S*?)[^>]*>.*?|<.*? />	匹配HTML标记
 * ^\s*|\s*$	匹配首尾空白字符
 * \w+([-+.]\w+)*@\w+([-.]\w+)*.\w+([-.]\w+)*	匹配Email地
 * [a-zA-z]+://[^\s]*	匹配网址URL
 * \d{3}-\d{8}|\d{4}-\d{7}	匹配国内电话号码,匹配形式如 0511-4405222 或 021-87888822
 * [1-9]\d{5}(?!\d)	匹配中国邮政编码
 * \d+.\d+.\d+.\d+	匹配ip地址
 *
 */

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark 是否空字符串
- (BOOL)isEmptyString {
    if (![self isKindOfClass:[NSString class]]) {
        return TRUE;
    }else if (self==nil) {
        return TRUE;
    }else if(!self) {
        // null object
        return TRUE;
    } else if(self==NULL) {
        // null object
        return TRUE;
    } else if([self isEqualToString:@"NULL"]) {
        // null object
        return TRUE;
    }else if([self isEqualToString:@"(null)"]){
        
        return TRUE;
    }else{
        //  使用whitespaceAndNewlineCharacterSet删除周围的空白字符串
        //  然后在判断首位字符串是否为空
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return TRUE;
        } else {
            // is neither empty nor null
            return FALSE;
        }
    }
}

#pragma mark 判断是否是手机号
- (BOOL)checkTel { //^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    NSString *regex = @"^(13[\\d]{9}|15[\\d]{9}|18[\\d]{9}|14[5,7][\\d]{8}|17[6,7,8][\\d]{8})$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

#pragma mark 判断是否是邮箱
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - 验证是否为有效Url
- (BOOL)isValidURL {
    NSString *regex = @"^(http|https)://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

#pragma mark - 判断是否为数字
- (BOOL)isNumber {
    NSString *regex = @"(/^[0-9]*$/)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHS %@", regex];
    return [pred evaluateWithObject:self];
}

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark 返回沙盒中的文件路径
+ (NSString *)stringWithDocumentsPath:(NSString *)path {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [file stringByAppendingPathComponent:path];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
