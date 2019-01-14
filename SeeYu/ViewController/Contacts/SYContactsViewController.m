//
//  SYContactsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYContactsViewController.h"
#import "SYAddFriendsViewController.h"
@interface SYContactsViewController ()<UISearchResultsUpdating>
/// viewModel
@property (nonatomic, readonly, strong) SYContactsViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SYContactsViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}


#pragma mark - 初始化
- (void)_setup{
    /// 监听searchVc的活跃度
    [RACObserve(self, searchController.active)
     subscribeNext:^(NSNumber * active) {
         NSLog(@"active is %zd",active.boolValue);
     }];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_addfriends_30x30" target:nil selector:nil textType:NO];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.addFriendsCommand;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{

//    SYAddFriendsViewModel *viewModel = [[SYAddFriendsViewModel alloc] initWithServices:self.viewModel.services params:nil];
//    SYAddFriendsViewController *add = [[SYAddFriendsViewController alloc] initWithViewModel:viewModel];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
    UISearchBar *bar = self.searchController.searchBar;
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = SYColor(248, 248, 248);
    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
//    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
//    view.layer.borderColor = [UIColor redColor].CGColor;
//    view.layer.borderWidth = 1;
    
    bar.layer.borderColor = [UIColor redColor].CGColor;
    
    bar.showsBookmarkButton = YES;
    [bar setImage:SYImageNamed(@"VoiceSearchStartBtn") forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
//    bar.delegate = self;
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    self.tableView.tableHeaderView = bar;

    
    
    
    self.searchController.searchResultsUpdater = self;
}

// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
@end
