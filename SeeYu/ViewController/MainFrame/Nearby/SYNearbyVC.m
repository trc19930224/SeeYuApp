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
    [self _setupSubViews];
}

- (void)_setupSubViews {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.f;    // 上下间距
    layout.minimumInteritemSpacing = 3.f;   // 左右间距
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
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
        if (self.viewModel.currentPageValues.count < self.viewModel.pageSize) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
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
    cell.layer.cornerRadius = 3.5f;
    cell.layer.masksToBounds = YES;
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    if (user.userGender != nil && user.userGender.length > 0) {
        cell.contentView.backgroundColor = [user.userGender isEqualToString:@"男"] ? SYColorFromHexString(@"#BCE3FE") : SYColorFromHexString(@"#FAD1FF");
        cell.defaultImageView.image = [user.userGender isEqualToString:@"男"] ? SYImageNamed(@"boy_default_bg") : SYImageNamed(@"girl_default_bg");
    }
    if (user.userName != nil && user.userName.length > 0) {
        cell.aliasLabel.text = user.userName;
    } else {
        cell.aliasLabel.text = @"";
    }
    if (user.userSignature != nil && user.userSignature.length > 0) {
        cell.signatureLabel.text = user.userSignature;
    } else {
        cell.signatureLabel.text = @"";
    }
    if (user.userVipStatus == 1) {
        if (user.userVipExpiresAt != nil) {
            if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                // 已过期
                cell.vipImageView.hidden = YES;
            } else {
                // 未过期
                cell.vipImageView.hidden = NO;
            }
        }
    } else {
        cell.vipImageView.hidden = YES;
    }
    if (user.userHeadImg != nil && user.userHeadImg.length > 0) {
        [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:[UIImage imageWithColor:[UIColor clearColor]] options:SYWebImageOptionAutomatic completion:NULL];
    } else {
        cell.headImageView.image = nil;
    }
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if ([cache containsObjectForKey:[NSString stringWithFormat:@"distance_%@",user.userId]]) {
        // 有缓存数据优先读取缓存数据
        id value = [cache objectForKey:[NSString stringWithFormat:@"distance_%@",user.userId]];
        NSString *distance = (NSString *) value;
        cell.distanceLabel.text = [NSString stringWithFormat:@"距离%@km",distance];
    } else {
        NSString *distance = [self getRandomDistance];
        cell.distanceLabel.text = [NSString stringWithFormat:@"距离%@km",distance];
        [cache setObject:distance forKey:[NSString stringWithFormat:@"distance_%@",user.userId]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    [self.viewModel.enterFriendDetailCommand execute:user.userId];
}

- (NSString *)getRandomDistance {
    NSString *distance = [NSString stringWithFormat:@"%d.%d%d",arc4random() % 10,arc4random() % 10,arc4random() % 10];
    return distance;
}

@end
