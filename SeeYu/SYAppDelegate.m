//
//  AppDelegate.m
//  SeeYu
//
//  Created by trc on 2019/01/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYAppDelegate.h"
#import "SYHomePageVC.h"
#import "SYRegisterVM.h"
#import "SYRCIMDataSource.h"
#import "SYGuideVM.h"
//#import <UMCommon/UMCommon.h>
//#import <UMPush/UMessage.h>
#import <FFToast/FFToast.h>

#if defined(DEBUG)||defined(_DEBUG)
#import <JPFPSStatus/JPFPSStatus.h>
//#import <FBMemoryProfiler/FBMemoryProfiler.h>
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
//#import "CacheCleanerPlugin.h"
//#import "RetainCycleLoggerPlugin.h"
#endif

@interface AppDelegate () <RCIMReceiveMessageDelegate>

/// APP管理的导航栏的堆栈
@property (nonatomic, readwrite, strong) SYNavigationControllerStack *navigationControllerStack;
/// APP的服务层
@property (nonatomic, readwrite, strong) SYViewModelServicesImpl *services;

@end

@implementation AppDelegate

//// 应用启动会调用的
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 初始化UI之前配置
    [self _configureApplication:application initialParamsBeforeInitUI:launchOptions];
    
    // Config Service
    self.services = [[SYViewModelServicesImpl alloc] init];
    // Config Nav Stack
    self.navigationControllerStack = [[SYNavigationControllerStack alloc] initWithServices:self.services];
    // Configure Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 重置rootViewController
    SYVM *vm = [self _createInitialViewModel];
    if ([vm isKindOfClass:[SYHomePageVM class]]) {
        [[RCIM sharedRCIM] connectWithToken:self.services.client.currentUser.userToken     success:^(NSString *userId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RCUserInfo *rcUser = [[RCUserInfo alloc]initWithUserId:userId name:self.services.client.currentUser.userName portrait:self.services.client.currentUser.userHeadImg];
                [RCIM sharedRCIM].currentUserInfo = rcUser;
                [MBProgressHUD sy_showTips:@"登录成功"];
            });
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            // token永久有效，这种情形应该不会出现
            NSLog(@"token错误");
        }];
    }
    [self.services resetRootViewModel:vm];
    // 让窗口可见
    [self.window makeKeyAndVisible];
    
    /// 初始化UI后配置
    [self _configureApplication:application initialParamsAfterInitUI:launchOptions];
    
#if defined(DEBUG)||defined(_DEBUG)
    /// 调试模式
    [self _configDebugModelTools];
#endif
    
    // Save the application version info. must write last
    [[NSUserDefaults standardUserDefaults] setValue:SY_APP_VERSION forKey:SYApplicationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"收到的推送消息内容为:%@",remoteNotificationUserInfo);
    return YES;
}



#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions
{
    /// 显示状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /// 配置键盘
    [self _configureKeyboardManager];
    
    /// 配置文件夹
    [self _configureApplicationDirectory];
    
    /// 配置FMDB
    [self _configureFMDB];
    
    // 初始化融云服务
    [[RCIM sharedRCIM] initWithAppKey:@"c9kqb3rdc4vbj"];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;  // 开启用户信息持久化
    [RCIM sharedRCIM].receiveMessageDelegate = self;    // 设置接收消息代理
    [RCIM sharedRCIM].userInfoDataSource = [SYRCIMDataSource shareInstance];
    [RCIM sharedRCIM].enableTypingStatus = YES; // 开启输入状态监听
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didReceiveMessageNotification:)
//                                                 name:RCKitDispatchMessageNotification
//                                               object:nil];
//    // 初始化友盟推送服务
//    [UMConfigure initWithAppkey:@"5ca1a3aa3fc195e05e0000df" channel:@"App Store"];
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//
//        } else {
//
//        }
//    }];
    
    // 注册推送, 用于iOS8以及iOS8之后的系统
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
}

/// 配置文件夹
- (void)_configureApplicationDirectory
{
    /// 创建doc
    [SYFileManager createDirectoryAtPath:SYSeeYuDocDirPath()];
    /// 创建cache
    [SYFileManager createDirectoryAtPath:SYSeeYuCacheDirPath()];
    
    NSLog(@"SYSeeYuDocDirPath is [ %@ ] \n SYSeeYuCacheDirPath is [ %@ ]" , SYSeeYuDocDirPath() , SYSeeYuCacheDirPath());
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置FMDB
- (void) _configureFMDB
{
//    [[FMDatabaseQueue sharedInstance] inDatabase:^(FMDatabase *db) {
//        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:SBApplicationVersionKey];
//        if (![version isEqualToString:SB_APP_VERSION]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"senba_empty_1.0.0" ofType:@"sql"];
//            NSString *sql  = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            /// 执行文件
//            if (![db executeStatements:sql]) {
//                SBLogLastError(db);
//            }
//        }
//    }];
}

#pragma mark - 在初始化UI之后配置
- (void)_configureApplication:(UIApplication *)application initialParamsAfterInitUI:(NSDictionary *)launchOptions
{
    /// 配置ActionSheet
    [LCActionSheet sy_configureActionSheet];
    
    /// 预先配置平台信息
//    [SBUMengService configureUMengPreDefinePlatforms];
    
    /// 设置状态栏全局字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    @weakify(self);
    /// 监听切换根控制器的通知
    [[SYNotificationCenter rac_addObserverForName:SYSwitchRootViewControllerNotification object:nil] subscribeNext:^(NSNotification * note) {
        /// 这里切换根控制器
        @strongify(self);
        // 重置rootViewController
        SYSwitchRootViewControllerFromType fromType = [note.userInfo[SYSwitchRootViewControllerUserInfoKey] integerValue];
        NSLog(@"fromType is  %zd" , fromType);
        /// 切换根控制器
        SYVM *vm = [self _createInitialViewModel];
        if ([vm isKindOfClass:[SYHomePageVM class]]) {
            [[RCIM sharedRCIM] connectWithToken:self.services.client.currentUser.userToken     success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCUserInfo *rcUser = [[RCUserInfo alloc]initWithUserId:userId name:self.services.client.currentUser.userName portrait:self.services.client.currentUser.userHeadImg];
                    [RCIM sharedRCIM].currentUserInfo = rcUser;
                    [self.services resetRootViewModel:vm];
                    [MBProgressHUD sy_showTips:@"登录成功"];
                });
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%long", status);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.services resetRootViewModel:vm];
                    [MBProgressHUD sy_showTips:[NSString stringWithFormat:@"连接IM服务器异常%long",status]];
                });
            } tokenIncorrect:^{
                // token永久有效，这种情形应该不会出现
                NSLog(@"token错误");
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.services resetRootViewModel:vm];
            });
        }
    }];
    
    /// 配置H5
//    [SBConfigureManager configure];
}

#pragma mark - 调试(DEBUG)模式下的工具条
- (void)_configDebugModelTools
{
    
#if defined(DEBUG)||defined(_DEBUG)
    /// 显示FPS
    [[JPFPSStatus sharedInstance] open];
#endif
}

#pragma mark - 创建根控制器
- (SYVM *)_createInitialViewModel {
    /// 这里判断一下
    if ([SAMKeychain rawLogin] && self.services.client.currentUser) {
        /// 已经登录，跳转到主页
        return [[SYHomePageVM alloc] initWithServices:self.services params:nil];
    } else {
        /// 进入首页
        return [[SYGuideVM alloc] initWithServices:self.services params:nil];
    }
}
#pragma mark- 获取appDelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// 注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// 上传deviceToekn到融云服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken为:%@",token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"%@",message);
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
        // NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        NSLog(@"%@",msg.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            [FFToast showToastWithTitle:@"系统" message:msg.message iconImage:SYImageNamed(@"header_default_100x100") duration:2 toastType:FFToastTypeDefault];
        });
    }
}

//- (void)didReceiveMessageNotification:(NSNotification *)notification {
//    NSLog(@"测试效果%@",notification);
//    NSNumber *left = [notification.userInfo objectForKey:@"left"];
//    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
//        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//                                                                             @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
//                                                                             @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
//                                                                             ]];
//        dispatch_async(dispatch_get_main_queue(),^{
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
//        });
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
