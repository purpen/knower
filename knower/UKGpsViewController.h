//
//  UKGpsViewController.h
//  knower
//
//  Created by xiaoyi on 16/3/9.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UKPoiListModel.h"

@protocol UKGpsViewControllerDelegate <NSObject>

@optional
- (void)getCoordinateFromController:(UKPoiListModel *)poi;

@end

@interface UKGpsViewController : UIViewController


@property (nonatomic, weak) id<UKGpsViewControllerDelegate> delegate;

@end
