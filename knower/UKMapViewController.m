//
//  UKMapViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/8.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKMapViewController.h"
#import "UKConfig.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface UKMapViewController () <BMKMapViewDelegate> {
    BMKMapView *_mapView;
}

@end

@implementation UKMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"导航";
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    self.view = _mapView;
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
