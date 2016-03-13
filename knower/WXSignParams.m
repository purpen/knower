//
//  WXSignParams.m
//  parrot
//
//  Created by THN-Huangfei on 16/1/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "WXSignParams.h"

#import "MJExtension.h"
#import "NSString+FBMD5.h"

@implementation WXSignParams

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"appid"] isKindOfClass:[NSNull class]]){
        self.appid = dictionary[@"appid"];
    }
    if(![dictionary[@"nonce_str"] isKindOfClass:[NSNull class]]){
        self.noncestr = dictionary[@"nonce_str"];
    }
    if(![dictionary[@"partner_id"] isKindOfClass:[NSNull class]]){
        self.partnerid = dictionary[@"partner_id"];
    }
    if(![dictionary[@"prepay_id"] isKindOfClass:[NSNull class]]){
        self.prepayid = dictionary[@"prepay_id"];
    }
    if(![dictionary[@"time_stamp"] isKindOfClass:[NSNull class]]){
        self.timestamp = [dictionary[@"time_stamp"] stringValue];
    }
    if(![dictionary[@"key"] isKindOfClass:[NSNull class]]){
        self.key = dictionary[@"key"];
    }
    self.package = @"Sign=WXPay";
    
    return self;
}

- (NSString *)sign
{
    NSDictionary *dic = [self mj_keyValues];
    return [self createMd5Sign:[dic mutableCopy]];
}

- (NSString*)createMd5Sign:(NSMutableDictionary *)dict
{
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
//    //添加key字段
    [contentString appendFormat:@"key=%@", self.key];//商户号对应密钥
    //得到MD5 sign签名
    NSString *md5Sign = [[NSString getMd5_32Bit_String:contentString] uppercaseString];
    
    return md5Sign;
}

@end
