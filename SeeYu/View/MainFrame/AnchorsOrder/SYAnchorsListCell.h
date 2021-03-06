//
//  SYAnchorsListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsListCell : UICollectionViewCell

// 头像
@property (nonatomic, strong) UIImageView *headImageView;

// 皇冠图标
@property (nonatomic, strong) UIImageView *crownImageView;

// 昵称
@property (nonatomic, strong) UILabel *aliasLabel;

// 签名
@property (nonatomic, strong) UILabel *signatureLabel;

// 语聊图片
@property (nonatomic, strong) UIImageView *voiceImageView;

// 钻石图片
@property (nonatomic, strong) UIImageView *diamondImageView;

// 语聊价格
@property (nonatomic, strong) UILabel *voicePriceLabel;

// 在线状态
@property (nonatomic, strong) UIImageView *onlineStatusImageView;

// 渐变色毛玻璃效果
@property (nonatomic, strong) UIImageView *bgImageView;

- (void)setStarsByLevel:(int)level;

- (void)setTipsByHobby:(NSString*)hobby;

- (void)removeHobbyTips;

@end

NS_ASSUME_NONNULL_END
