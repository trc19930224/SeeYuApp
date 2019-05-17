//
//  SYNearbyVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYNearbyVM.h"
#import "SYNearbyListCell.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNearbyVC : SYVC <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *city;

@end

NS_ASSUME_NONNULL_END
