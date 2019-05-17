//
//  SYNearbyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYNearbyVC.h"
#import "UIScrollView+SYRefresh.h"

@interface SYNearbyVC ()

@property (nonatomic, readwrite, strong) SYNearbyVM *viewModel;

@end

NSString * const nearybyListCell = @"nearybyListCell";

@implementation SYNearbyVC

@dynamic viewModel;

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (instancetype)initWithViewModel:(SYNearbyVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestNearbyFriendsCommand execute:@1];
            }];
        }
    }
    return self;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[RACObserve(self.viewModel, dataSource)
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         // 刷新数据
         [self.collectionView reloadData];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取用户地理位置
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;   //最佳精度
    [self startLocating];   // 开启定位
    [self _setupSubViews];
}

#pragma mark - 开始定位
- (void)startLocating {
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];   //开始定位
}

/* 定位完成后 回调 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    [manager stopUpdatingLocation];   //停止定位
    CLGeocoder *geoCoder = [CLGeocoder new];
    @weakify(self)
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        @strongify(self)
        CLPlacemark *pl = [placemarks firstObject];
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            
            NSLog(@"%@", pl.locality);
            self.city = pl.locality;
            [self.collectionView reloadData];
        }
    }];
}

/* 定位失败后 回调 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
        [MBProgressHUD sy_showTips:@"定位失败，请检查"];
    }
}
/* 监听用户授权状态 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 用户未开启定位功能
    }
}

- (void)_setupSubViews {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.f;    // 上下间距
    layout.minimumInteritemSpacing = 3.f;   // 左右间距
    layout.itemSize = CGSizeMake((SY_SCREEN_WIDTH - 15.f) / 2, (SY_SCREEN_WIDTH - 15.f) / 2);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;   // 垂直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = self.view.backgroundColor;
    [collectionView registerClass:[SYNearbyListCell class] forCellWithReuseIdentifier:nearybyListCell];
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 添加下拉刷新控件
    @weakify(self);
    [_collectionView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self collectionViewDidTriggerHeaderRefresh];
    }];
    [_collectionView.mj_header beginRefreshing];
    
    /// 上拉加载
    [_collectionView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self collectionViewDidTriggerFooterRefresh];
    }];
}

#pragma mark - 下拉刷新事件
- (void)collectionViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestNearbyFriendsCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum = 1;
        [self.collectionView.mj_footer resetNoMoreData];
    } error:^(NSError *error) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
    }];
}

#pragma mark - 上拉刷新事件
- (void)collectionViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestNearbyFriendsCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum += 1;
    } error:^(NSError *error) {
        @strongify(self);
        [self.collectionView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYNearbyListCell * cell = (SYNearbyListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:nearybyListCell forIndexPath:indexPath];
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    if (user.userGender != nil && user.userGender.length > 0) {
//        cell.contentView.backgroundColor = 
    }
    if (user.userName != nil && user.userName.length > 0) {
        cell.aliasLabel.text = user.userName;
    }
    if (user.userSignature != nil && user.userSignature.length > 0) {
        cell.signatureLabel.text = user.userSignature;
    }

//    [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:model.showPhoto] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    [self.viewModel.enterFriendDetailCommand execute:user.userId];
}

@end
