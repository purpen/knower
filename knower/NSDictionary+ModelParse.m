//
//  NSDictionary+ModelParse.m
//  parrot
//
//  Created by xiaoyi on 15/11/12.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "NSDictionary+ModelParse.h"

@implementation NSDictionary (ModelParse)

- (NSString *)stringValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }else{
        if ([obj isKindOfClass:[NSNull class]]) {
            return @"";
        }
        return [NSString stringWithFormat:@"%@", obj];
    }
}

- (long)longValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        return 0;
    }
    if (obj) {
        return [obj longValue];
    }else{
        return 0;
    }
}

- (int)intValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        return 0;
    }
    if (obj) {
        return [obj intValue];
    }else{
        return 0;
    }
}

- (float)floatValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        return 0.0f;
    }
    if (obj) {
        return [obj floatValue];
    }else{
        return 0.0;
    }
}

- (double)doubleValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        return 0.0;
    }
    if (obj) {
        return [obj doubleValue];
    }else{
        return 0.0;
    }
}

- (BOOL)boolValueForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        // warning 当服务端返回值为空时候默认置为NO
        return NO;
    }
    if (obj) {
        return [obj boolValue];
    }else{
        return NO;
    }
}

@end
