//
//  UIImage+Helper.h
//  Hospital
//
//  Created by ios on 15/3/31.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

#pragma mark 默认从图片中心点开始拉伸图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
