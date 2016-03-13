//
//  NSDictionary+ModelParse.h
//  parrot
//
//  Created by xiaoyi on 15/11/12.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ModelParse)

- (NSString *)stringValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (long)longValueForKey:(NSString *)key;

@end
