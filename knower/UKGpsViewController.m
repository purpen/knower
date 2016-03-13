//
//  UKGpsViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/9.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKGpsViewController.h"

#import "MJRefresh.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件

@interface UKGpsViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,BMKPoiSearchDelegate> {
    
    BMKLocationService *_locationService;
    BMKPoiSearch *_poiSearch;
    
    NSMutableArray *_poilist;
    CLLocationCoordinate2D curPoint;
    NSString *_keyword;
    int curPage;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UKGpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所在位置";
    
    // 渲染控件
    [self buildViewAppearance];
    
    // 初始化
    _poilist = [[NSMutableArray alloc] init];
    curPage  = 0;
    // 景点、美食、购物、生活服务、娱乐休闲、运动健身
    _keyword = @"景点";
    
    // 初始化定位管理器
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    
    // 启动LocationService
    [_locationService startUserLocationService];
    
    //初始化检索对象
    _poiSearch =[[BMKPoiSearch alloc] init];
    _poiSearch.delegate = self;
    
    // 搜索框
    _searchBar.delegate = self;
    
    // 设置tableview代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    
    // 加载更多
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

// 加载自定义控件
- (void)buildViewAppearance {
    NSLog(@"init view appearance!");
}

// 初始化数据
- (void)initData {
    curPage = 0;
    NSLog(@"load init page: %u", curPage);
    [self requestSearchPoiList];
    
    [_tableView.mj_header endRefreshing];
}

// 加载更多附近位置
- (void)loadMoreData {
    curPage++;
    NSLog(@"load more page: %u", curPage);
    [self requestSearchPoiList];
    [_tableView.mj_footer endRefreshing];
}

// 发起检索
- (void)requestSearchPoiList {
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = curPage;
    option.pageCapacity = 10;
    option.location = curPoint;
    option.keyword = _keyword;
    option.radius  = 3000;
    BOOL flag = [_poiSearch poiSearchNearBy:option];
    
    if (flag) {
        NSLog(@"Poi检索发送成功！");
    } else {
        NSLog(@"Poi检索发送失败！");
    }
}

#pragma mark - BMKLocationServiceDelegate
// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    // 反地理编码，根据地理坐标获取位置
    curPoint = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    // 建议获取完经纬后停止位置更新  否则会一直更新坐标
    if (userLocation.location.coordinate.latitude != 0) {
        [_locationService stopUserLocationService];
    }
    
    // 根据中心点检索poi
    [self initData];
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        if (curPage == 0 && [_poilist count] > 0) {
            [_poilist removeAllObjects];
        }
        for (BMKPoiInfo *pi in poiResult.poiInfoList) {
            
            UKPoiListModel *loc = [[UKPoiListModel alloc] init];
            loc.uid = pi.uid;
            loc.name = pi.name;
            loc.address = pi.address;
            loc.city = pi.city;
            loc.pt   = pi.pt;
            
            [_poilist addObject:loc];
        }
        
        // 刷新数据
        [_tableView reloadData];
        
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，没有匹配结果！");
    }
}

// 不使用时将delegate设置为nil
- (void)viewWillDisappear:(BOOL)animated {
    _poiSearch.delegate = nil;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_poilist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:showUserInfoCellIdentifier];
    }
    // [cell layoutSubviews];
    cell.textLabel.tintColor = [UIColor blackColor];
    cell.detailTextLabel.tintColor = [UIColor grayColor];
    
    UKPoiListModel *poi = [_poilist objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", poi.city, poi.address];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UKPoiListModel *select_poi = [_poilist objectAtIndex:indexPath.row];
    
    // 传递参数
    [self.delegate getCoordinateFromController:select_poi];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISearchBarDelegate
// 当textview的文字改变或清除时调用此方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"search text: %@", searchText);
    if (searchText) {
        _keyword = searchText;
        [self initData];
    }
}

// 当编辑完成后调用
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
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
