//
//  WXSignParams.h
//  parrot
//
//  Created by THN-Huangfei on 16/1/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSignParams : NSObject

@property (nonatomic, strong) NSString * appid;
@property (nonatomic, strong) NSString * noncestr;
@property (nonatomic, strong) NSString * partnerid;
@property (nonatomic, strong) NSString * prepayid;
@property (nonatomic, strong) NSString * timestamp;

@property (nonatomic, strong) NSString * key;

@property (nonatomic, strong) NSString * package;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)sign;

@end
