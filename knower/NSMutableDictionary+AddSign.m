//
//  NSMutableDictionary+AddSign.m
//  parrot
//
//  Created by xiaoyi on 15/11/12.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "NSMutableDictionary+AddSign.h"

#import "NSString+FBMD5.h"
//#import "FBUserManger.h"

@implementation NSMutableDictionary (AddSign)

// 加密签名规则
- (void)addSign {
    NSArray *keys = [self allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        int tmp = 0; // 比到第几位
        NSNumber *key1;
        NSNumber *key2;
        do {
            if (tmp > ([(NSString *)obj1 length]-1)) {
                NSAssert((tmp <= ([(NSString *)obj2 length]-1)), @"传入了两个完全相同的参数！");
                key1 = [NSNumber numberWithShort:0];
                key2 = [NSNumber numberWithShort:[(NSString *)obj2 characterAtIndex:tmp]];
                break;
            }
            
            if (tmp > ([(NSString *)obj2 length]-1)) {
                NSAssert((tmp <= ([(NSString *)obj1 length]-1)), @"传入了两个完全相同的参数！");
                key2 = [NSNumber numberWithShort:0];
                key1 = [NSNumber numberWithShort:[(NSString *)obj1 characterAtIndex:tmp]];
                break;
            }
            key1 = [NSNumber numberWithShort:[(NSString *)obj1 characterAtIndex:tmp]];
            key2 = [NSNumber numberWithShort:[(NSString *)obj2 characterAtIndex:tmp]];
            tmp++;
        } while ([key1 intValue] == [key2 intValue]);
        
        NSComparisonResult result = [key1 compare:key2];
        return result == NSOrderedDescending;
    }];
    
    NSMutableString *paraStr = [NSMutableString stringWithCapacity:0];
    int i = 0;
    for (NSString *key in sortedKeys) {
        NSString *value = [self objectForKey:key];
        if (i == 0) {
            [paraStr appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
        }else{
            [paraStr appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
        i++;
    }
//    
//    [paraStr appendString:[FBUserManger clientSecret]];
//    [paraStr appendString:[FBUserManger clientId]];
    
    // 两次MD5
    NSString *signStrTmp = [paraStr FBMD5Hash32];
    NSString *signStr = [signStrTmp FBMD5Hash32];
    
    
    [self setObject:signStr forKey:@"sign"];
}

@end
