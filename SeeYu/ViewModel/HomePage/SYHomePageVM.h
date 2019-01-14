//
//  SYHomePageVM.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  主界面的视图的视图模型

#import "SYTabBarViewModel.h"
#import "SYMainFrameViewModel.h"
#import "SYContactsViewModel.h"
#import "SYDiscoverViewModel.h"
#import "SYProfileVM.h"
@interface SYHomePageVM : SYTabBarViewModel
/// The view model of `MainFrame` interface.
@property (nonatomic, strong, readonly) SYMainFrameViewModel *mainFrameViewModel;

/// The view model of `contacts` interface.
@property (nonatomic, strong, readonly) SYContactsViewModel *contactsViewModel;

/// The view model of `discover` interface.
@property (nonatomic, strong, readonly) SYDiscoverViewModel *discoverViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readonly) SYProfileVM *profileViewModel;
@end
