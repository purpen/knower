//
//  UKPoiListModel.h
//  knower
//
//  Created by xiaoyi on 16/3/9.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UKPoiListModel : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;

@property (nonatomic) CLLocationCoordinate2D pt;

@end
