//
//  UKLocationViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/9.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKLocationViewController.h"

#import "UKConfig.h"
#import "UKLocationCell.h"
#import "UKPoiListModel.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件


@interface UKLocationViewController () <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
    BMKLocationService *_locationService;
    BMKGeoCodeSearch *_geoCodeSearch;
    
    NSMutableArray *_poilist;
}

@property (nonatomic, strong) NSString *selectedLocation;

@end

static NSString *locCellIdentifier = @"UKLocationCell";

@implementation UKLocationViewController

- (id)init {
    if (self = [super init]) {
        _poilist = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"选择位置";
    
    // 注册cell，优化
    [self.tableView registerClass:[UKLocationCell class] forCellReuseIdentifier:locCellIdentifier];
    
    // 初始化定位管理器
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    // 启动LocationService
    [_locationService startUserLocationService];
}


#pragma mark - BMKLocationServiceDelegate
// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
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
        NSLog(@"%@", result.poiList);
        
        _selectedLocation = result.addressDetail.city;
        
        for (BMKPoiInfo *pi in result.poiList) {
            
            UKPoiListModel *loc = [[UKPoiListModel alloc] init];
            loc.uid = pi.uid;
            loc.name = pi.name;
            loc.address = pi.address;
            loc.city = pi.city;
            
            [_poilist addObject:loc];
        }
        
        NSLog(@"POI Count: %lu", (unsigned long)[_poilist count]);
        
        // 刷新数据
        [self.tableView reloadData];
        
    } else {
        NSLog(@"抱歉，没有匹配结果！");
    }
}

// 不使用时将delegate设置为nil
- (void)viewWillDisappear:(BOOL)animated {
    _geoCodeSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_poilist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UKLocationCell *cell = (UKLocationCell *)[tableView dequeueReusableCellWithIdentifier:locCellIdentifier forIndexPath:indexPath];
    
    NSLog(@"Cell row: %ld", (long)indexPath.row);
    UKPoiListModel *poi = [_poilist objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = poi.name;
    cell.descLabel.text = poi.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
