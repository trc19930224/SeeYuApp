//
//  SYRankListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYRankListVC.h"

@interface SYRankListVC ()

@property (nonatomic, strong) SYRankListVM *viewModel;

@end

@implementation SYRankListVC

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self)
            /// 请求第一页的网络数据
            [self.viewModel.requestRankListCommand execute:nil];
        }];
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
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
}

- (void)_setupSubViews {
    SYTableView *tableView = [[SYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // 添加下拉刷新控件
    @weakify(self);
    [self.tableView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self.viewModel.requestRankListCommand execute:nil];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    if (@available(iOS 11.0, *)) {
        SYAdjustsScrollViewInsets_Never(tableView);
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    CGFloat margin = (SY_SCREEN_WIDTH / 2 - 42.5 - 65 - 2.5) / 2;
    if (indexPath.row == 0) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = SYImageNamed(@"rankList_bg");
        bgImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(cell.contentView).offset(-5);
            make.centerX.top.equalTo(cell.contentView);
            make.height.offset(145);
        }];
        for (int i = 0; i < 3; i++) {
            SYRankListModel *model = self.viewModel.dataSource[i];
            UIImageView *headImageView = [UIImageView new];
            if (model.userHeadImg != nil && model.userHeadImg.length > 0 && model.userHeadImgFlag == 1) {
                [headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
            } else {
                headImageView.image = SYImageNamed(@"anchor_deafult_image");
            }
            [bgImageView addSubview:headImageView];
            
            UIImageView *backImageView = [UIImageView new];
            backImageView.userInteractionEnabled = YES;
            backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranklist_head_%d",i]];
            [bgImageView addSubview:backImageView];
            [bgImageView bringSubviewToFront:backImageView];
            
            if (i == 0) {
                headImageView.layer.cornerRadius = 37.5f;
            } else {
                headImageView.layer.cornerRadius = 29.f;
            }
            headImageView.layer.masksToBounds = YES;
            
            UILabel *aliasLabel = [UILabel new];
            aliasLabel.textAlignment = NSTextAlignmentCenter;
            aliasLabel.font = SYFont(11, YES);
            aliasLabel.backgroundColor = SYColorAlpha(157, 76, 213, 0.8);
            aliasLabel.textColor = SYColor(255, 240, 0);
            aliasLabel.layer.borderWidth = 1.f;
            aliasLabel.layer.borderColor = SYColorAlpha(207, 144, 251, 0.8).CGColor;
            aliasLabel.layer.cornerRadius = 10.f;
            aliasLabel.layer.masksToBounds = YES;
            aliasLabel.text = model.userName;
            [cell.contentView addSubview:aliasLabel];
            
            UILabel *consumLabel = [UILabel new];
            if ([self.viewModel.listType isEqualToString:@"anchor"]) {
                // 主播魅力值
                consumLabel.text = [NSString stringWithFormat:@"魅力值%@",model.score];
            } else if ([self.viewModel.listType isEqualToString:@"localTyrant"]) {
                // 土豪消费值
                consumLabel.text = [NSString stringWithFormat:@"消费%@万",model.score];
            } else {
                // 用户活跃值
                consumLabel.text = [NSString stringWithFormat:@"活跃值%@",model.score];
            }
            consumLabel.textAlignment = NSTextAlignmentCenter;
            consumLabel.font = SYFont(10, YES);
            consumLabel.textColor = SYColor(255, 255, 255);
            consumLabel.backgroundColor = SYColorAlpha(157, 76, 213, 0.8);
            consumLabel.layer.borderWidth = 1.f;
            consumLabel.layer.borderColor = SYColorAlpha(207, 144, 251, 0.8).CGColor;
            consumLabel.layer.cornerRadius = 10.f;
            consumLabel.layer.masksToBounds = YES;
            [bgImageView addSubview:consumLabel];
            
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor clearColor];
            [cell addSubview:bgView];
            [cell bringSubviewToFront:bgView];
            UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
            [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
                SYRankListModel *model = self.viewModel.dataSource[i];
                if ([self.viewModel.listType isEqualToString:@"anchor"]) {
                    [self.viewModel.enterAnchorShowViewCommand execute:model.userId];
                } else {
                    [self.viewModel.enterFriendDetailInfoCommand execute:model.userId];
                }
            }];
            [bgView addGestureRecognizer:tapGesture];
            
            if (i == 0) {
                [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(85.f);
                    make.height.offset(95.f);
                    make.centerX.equalTo(bgImageView);
                    make.top.equalTo(bgImageView).offset(5.f);
                }];
                [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(75.f);
                    make.center.equalTo(backImageView);
                }];
            } else if (i == 1) {
                [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(65.f);
                    make.height.offset(80.f);
                    make.left.equalTo(bgImageView).offset(margin);
                    make.top.equalTo(bgImageView).offset(10.f);
                }];
                [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(58.f);
                    make.center.equalTo(backImageView);
                }];
            } else {
                [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(65.f);
                    make.height.offset(80.f);
                    make.right.equalTo(bgImageView).offset(-margin);
                    make.top.equalTo(bgImageView).offset(15.f);
                }];
                [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(58.f);
                    make.center.equalTo(backImageView);
                }];
            }
            [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(85);
                make.height.offset(20);
                make.top.equalTo(backImageView.mas_bottom);
                make.centerX.equalTo(backImageView);
            }];
            [consumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(aliasLabel.mas_bottom).offset(2);
                make.centerX.equalTo(backImageView);
                make.width.offset(85);
                make.height.offset(20);
            }];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backImageView);
                make.bottom.left.right.equalTo(consumLabel);
            }];
        }
    } else {
        SYRankListModel *model = self.viewModel.dataSource[indexPath.row + 2];
        
        // 序号背景
        UIImageView *orderBgImageView = [UIImageView new];
        orderBgImageView.image = SYImageNamed(@"number_bg");
        [cell.contentView addSubview:orderBgImageView];
        
        // 序号文本
        UILabel *orderNum = [UILabel new];
        orderNum.text = [NSString stringWithFormat:@"%ld", indexPath.row + 3];
        orderNum.font = SYFont(18, YES);
        orderNum.textColor = [UIColor whiteColor];
        orderNum.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:orderNum];
        
        // 头像
        UIImageView *headImageView = [UIImageView new];
        if (model.userHeadImg != nil && model.userHeadImg.length > 0 && model.userHeadImgFlag == 1) {
            [headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        } else {
            headImageView.image = SYImageNamed(@"anchor_deafult_image");
        }
        headImageView.layer.cornerRadius = 22.f;
        headImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImageView];
        
        // 昵称
        UILabel *aliasLabel = [UILabel new];
        aliasLabel.textAlignment = NSTextAlignmentLeft;
        aliasLabel.font = SYFont(11, YES);
        aliasLabel.textColor = SYColor(193, 99, 237);
        aliasLabel.text = model.userName;
        [cell.contentView addSubview:aliasLabel];
        
//        // id
//        UILabel *idLabel = [UILabel new];
//        idLabel.text = [NSString stringWithFormat:@"ID %@",model.userId];
//        idLabel.font = SYFont(10, YES);
//        idLabel.textColor = SYColor(193, 99, 237);
//        idLabel.textAlignment = NSTextAlignmentLeft;
//        [cell.contentView addSubview:idLabel];
        
        UILabel *customLabel = [UILabel new];
        if ([self.viewModel.listType isEqualToString:@"anchor"]) {
            // 主播魅力值
            customLabel.text = [NSString stringWithFormat:@"魅力值%@",model.score];
        } else if ([self.viewModel.listType isEqualToString:@"localTyrant"]) {
            // 土豪消费值
            customLabel.text = [NSString stringWithFormat:@"消费%@万",model.score];
        } else {
            // 用户活跃值
            customLabel.text = [NSString stringWithFormat:@"活跃值%@",model.score];
        }
        customLabel.font = SYFont(10, YES);
        customLabel.textAlignment = NSTextAlignmentRight;
        customLabel.textColor = SYColor(193, 99, 237);
        [cell addSubview:customLabel];
        
        // 下划线
        UIImageView *lineView = [UIImageView new];
        lineView.backgroundColor = SYColor(242, 242, 242);
        [cell.contentView addSubview:lineView];
        
        [orderBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(cell.contentView);
            make.width.offset(28);
            make.height.offset(20);
        }];
        [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(orderBgImageView);
            make.width.offset(22);
            make.centerY.equalTo(cell.contentView);
            make.height.offset(40);
        }];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.centerY.equalTo(cell);
            make.left.equalTo(orderNum.mas_right).offset(10);
        }];
        [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(9);
            make.height.offset(12);
            make.centerY.equalTo(headImageView) ;
        }];
//        [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(aliasLabel);
//            make.top.equalTo(aliasLabel.mas_bottom).offset(8);
//            make.height.offset(15);
//        }];
        [customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.height.offset(20);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.offset(1);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150.f;
    }
    return 62.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYRankListModel *model = self.viewModel.dataSource[indexPath.row + 2];
    if (indexPath.row != 0) {
        if ([self.viewModel.listType isEqualToString:@"anchor"]) {
            [self.viewModel.enterAnchorShowViewCommand execute:model.userId];
        } else {
            [self.viewModel.enterFriendDetailInfoCommand execute:model.userId];
        }
    }
}

@end
