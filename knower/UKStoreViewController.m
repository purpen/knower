//
//  UKStoreViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/4.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKStoreViewController.h"

#import "UKConfig.h"
#import "UKMapViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface UKStoreViewController () <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
    BMKLocationService *_locationService;
    BMKGeoCodeSearch *_geoCodeSearch;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation UKStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择位置";
    
    // 添加label点击事件
    //self.cityName.userInteractionEnabled = YES;
    //self.cityName.textColor = [UIColor blueColor];
    
    //UITapGestureRecognizer * labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bindClickEvent:)];
    //[self.currentCity addGestureRecognizer:labelTapGestureRecognizer];
    
    
    // 定位到当前所处位置
    
    // 定位管理器
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    // 启动LocationService
    [_locationService startUserLocationService];
    
    // 初始化
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    // 如果没有授权则请求用户授权
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        // 设置授权，需要配合plist文件里进行配置
//        [_locationManager requestWhenInUseAuthorization];
//    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        // 设置代理
//        _locationManager.delegate = self;
//        // 设置定位精度
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        
//        // 定位频率，每隔多少米定位一次
//        CLLocationDistance distance = 10.0;
//        _locationManager.distanceFilter = distance;
//        
//        // 启动跟踪定位
//        [_locationManager startUpdatingLocation];
//    }
    
    // 获取坐标
    // [self getCoordinateByAddress:@"北京"];
}

#pragma mark - BMKLocationServiceDelegate
// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    // self.currentCoordinate.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"地理坐标： %f, %f",userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude]];
    // 反地理编码，根据地理坐标获取位置
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"反Geo检索发送成功！");
    } else {
        NSLog(@"反Geo检索发送失败！");
    }
}

// 接收反向地理编码结果

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%@", result.addressDetail.city);
        // self.cityName.text = result.addressDetail.city;
        
        NSLog(@"%@", result.poiList);
        
        
    } else {
        NSLog(@"抱歉，没有匹配结果！");
    }
}

// 不使用时将delegate设置为nil
- (void)viewWillDisappear:(BOOL)animated {
    _geoCodeSearch.delegate = nil;
}

// 地址导航
- (void)bindClickEvent:(UITapGestureRecognizer *)recognizer {
    UKMapViewController *mapViewController = [[UKMapViewController alloc] init];
    [self.navigationController pushViewController:mapViewController animated:YES];
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
