//
//  UKRootViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/2.
//  Copyright © 2016年 urknow. All rights reserved.
//
#import "UKRootViewController.h"

#import "UKScanQrcodeViewController.h"

@interface UKRootViewController () {
    UKPoiListModel *_selectPoi;
}

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@end

@implementation UKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    // 定位按钮
    self.locationButton.tintColor = [UIColor orangeColor];    
}



// 根据定位选择位置
- (IBAction)bindChooseLocation:(id)sender {
    //UKLocationViewController *locationViewController = [[UKLocationViewController alloc] init];
    UKGpsViewController *gpsViewController = [[UKGpsViewController alloc] init];
    gpsViewController.delegate = self;
    
    [self.navigationController pushViewController:gpsViewController animated:YES];
}

#pragma mark - UKGpsViewControlerDelegate

- (void)getCoordinateFromController:(UKPoiListModel *)poi {
    _selectPoi = poi;
    NSLog(@"Select Point: %@,%@", _selectPoi.name, _selectPoi.address);
}


// 扫描二维码
- (IBAction)bindScanQrcode:(id)sender {
    UKScanQrcodeViewController *scanQrcodeViewController = [[UKScanQrcodeViewController alloc] init];
    [self.navigationController pushViewController:scanQrcodeViewController animated:YES];
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
