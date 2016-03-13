//
//  UKConfig.h
//  knower
//
//  Created by xiaoyi on 16/3/7.
//  Copyright © 2016年 urknow. All rights reserved.
//

#ifndef UKConfig_h
#define UKConfig_h

#define kAppDebug 1

#define kChannel              @"appstore";
// 客户端版本
#define kClientVersion        @"2.1.0"
#define kClientID             @"1415289600"
#define kClientSecret         @"545d9f8aac6b7a4d04abffe5"

#define kFontFamily           @"HelveticaNeue"

// App Store ID
#define kAppStoreId           @"FrBrid2.0"
#define kAppName              @"太火鸟+"

// Error Domain
#define kDomain               @"TaiHuoNiao"
#define kServerError          60001
#define kParseError           60002
#define kNetError             60003

#define kUserInfoPath         @"UK__StoreUserInfo__"
#define kLocalKeyUUID         @"UK__UUID__"

// 用户设备系统版本
#define IOS7_OR_LATER         ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER         ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

// 判断是否是4寸屏
#define IS_PHONE5             ( ([[UIScreen mainScreen] bounds].size.height-568) ? NO : YES )

// 屏幕宽高
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
// 起点定位
#define DOT_COORDINATE        0.0f
// 状态栏高度
#define STATUS_BAR_HEIGHT     20.0f
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT 44.0f
// 标签栏高度
#define TAB_TAB_HEIGHT        49.0f

#define View_Width  [[UIScreen mainScreen] bounds].size.width
#define View_Height [[UIScreen mainScreen] bounds].size.height

#define FBColor [UIColor colorWithHexString:@"#FF3366" alpha:1]
#define BGColor [UIColor colorWithHexString:@"#F1F1F1" alpha:1]
#define TTColor [UIColor colorWithHexString:@"#666666" alpha:1]

// 百度地图
#define kBaiduAK  @"2ueWgN1CGEXEXl0685I35Y6O"


// API ROOT URL
//#define kDomainBaseUrl @"http://api.urknow.com"       //生产环境
#define kDomainBaseUrl @"http://urknow.me/app/api"     //开发环境

#endif /* UKConfig_h */
