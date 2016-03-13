//
//  FBAPI.h
//  knower
//
//  Created by xiaoyi on 16/3/11.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBRequest.h"

@interface FBAPI : FBRequest

- (NSString *)uuid;
- (NSString *)time;

+ (instancetype)getWithUrlString:(NSString *)urlString
               requestDictionary:(NSDictionary *)requestDictionary
                        delegate:(id)delegate;

+ (instancetype)postWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                         delegate:(id)delegate;

+ (instancetype)uploadWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                           delegate:(id)delegate;

@end
