//
//  SYMomentProfileViewModel.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信朋友圈个人信息的视图模型

#import <Foundation/Foundation.h>
#import "SYMoments.h"
@interface SYMomentProfileViewModel : NSObject

/// 用户模型
@property (nonatomic, readonly, strong) SYUser *user;

/// 消息为读数
@property (nonatomic, readwrite, assign) NSInteger unread;
/// 未读消息的用户
@property (nonatomic, readwrite, strong) SYUser *unreadUser;


/// profileViewHeight
@property (nonatomic, readonly, assign) CGFloat height;

/// 昵称
@property (nonatomic, readonly, copy) NSAttributedString *screenNameAttr;

/// 消息tips
@property (nonatomic, readonly, copy) NSString *unreadTips;

/// init 
- (instancetype)initWithUser:(SYUser *)user;
@end
