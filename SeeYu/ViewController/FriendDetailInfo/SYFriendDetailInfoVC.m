//
//  SYFriendDetailInfoVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendDetailInfoVC.h"
#import "SYSingleChattingVC.h"
#import "SYRCIMDataSource.h"

@interface SYFriendDetailInfoVC () <UITableViewDelegate, UITableViewDataSource>

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *headerView;

// 展示头像
@property (nonatomic, strong) UIImageView *headImageView;

// 昵称文本
@property (nonatomic, strong) UILabel *aliasLabel;

// 在线状态
@property (nonatomic, strong) UIImageView *onlineImageView;

// 真人认证
@property (nonatomic, strong) UIImageView *personImageView;

// 手机认证
@property (nonatomic, strong) UIImageView *mobileImageView;

// 视频认证
@property (nonatomic, strong) UIImageView *videoImageView;

// 签名文本
@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UIView *functionView;

// 发送消息按钮
@property (nonatomic, strong) UIButton *sendMsgBtn;

// 发送消息文本
@property (nonatomic, strong) UILabel *sendMsgLabel;

// 打招呼按钮
@property (nonatomic, strong) UIButton *sayHiBtn;

// 打招呼文本
@property (nonatomic, strong) UILabel *sayHiLabel;

// 看一看按钮
@property (nonatomic, strong) UIButton *haveLookBtn;

// 看一看文本
@property (nonatomic, strong) UILabel *haveLookLabel;

// 加好友按钮
@property (nonatomic, strong) UIButton *addFriendBtn;

// 加好友文本
@property (nonatomic, strong) UILabel *addFriendLabel;

@property (nonatomic, strong) UIView *lineBgView1;

@property (nonatomic, strong) UIView *detailInfoView;

// 信息文本
@property (nonatomic, strong) UILabel *infoLabel;

// 爱好文本
@property (nonatomic, strong) UILabel *hobbyInfoLabel;

// 第一个爱好
@property (nonatomic, strong) UILabel *firstHobbyLabel;

// 第二个爱好
@property (nonatomic, strong) UILabel *secondHobbyLabel;

// 第三个爱好
@property (nonatomic, strong) UILabel *thirdHobbyLabel;

// 昵称文本
@property (nonatomic, strong) UILabel *aliasInfoLabel;

// 性别文本
@property (nonatomic, strong) UILabel *genderInfoLabel;

// 年龄文本
@property (nonatomic, strong) UILabel *ageInfoLabel;

// 城市文本
//@property (nonatomic, strong) UILabel *cityInfoLabel;

// 身高文本
@property (nonatomic, strong) UILabel *heightInfoLabel;

// 收入文本
//@property (nonatomic, strong) UILabel *incomeInfoLabel;

// 婚姻文本
@property (nonatomic, strong) UILabel *marryInfoLabel;

// ID文本
@property (nonatomic, strong) UILabel *IDInfoLabel;

// 微信文本
@property (nonatomic, strong) UILabel * wxInfoLabel;

// 微信
@property (nonatomic, strong) UILabel * wxNumberLabel;

// QQ文本
@property (nonatomic, strong) UILabel *qqInfoLabel;

// qq
@property (nonatomic, strong) UILabel * qqNumberLabel;

// 手机号文本
@property (nonatomic, strong) UILabel *mobileInfoLabel;

// 手机号
@property (nonatomic, strong) UILabel * mobileNumberLabel;

@property (nonatomic, strong) UIView *lineBgView2;

@end

@implementation SYFriendDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestFriendshipCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, friendInfo) subscribeNext:^(SYUser *friendInfo) {
        @strongify(self)
        // 设置展示头像
        if (friendInfo.userHeadImg != nil && friendInfo.userHeadImg.length > 0 && friendInfo.userHeadImgFlag == 1) {
            [self.headImageView yy_setImageWithURL:[NSURL URLWithString:friendInfo.userHeadImg] placeholder:SYImageNamed(@"anchor_deafult_image_wide") options:SYWebImageOptionAutomatic completion:NULL];
        } else {
            self.headImageView.image = SYImageNamed(@"anchor_deafult_image_wide");
        }
        // 设置昵称
        self.aliasLabel.text = friendInfo.userName;
        // 设置在线状态
        if ([friendInfo.userOnline isEqualToString:@"1"]) {
            self.onlineImageView.image = SYImageNamed(@"home_icon_online");
        } else {
            self.onlineImageView.image = SYImageNamed(@"home_icon_offline");
        }
        // 设置签名
        self.signatureLabel.text = friendInfo.userSignature;
        // 设置爱好
        if (![friendInfo.userSpecialty sy_isNullOrNil] && friendInfo.userSpecialty.length > 0) {
            NSArray *array = [friendInfo.userSpecialty componentsSeparatedByString:@","];
            if (array.count == 1) {
                self.firstHobbyLabel.text = array[0];
                self.firstHobbyLabel.hidden = NO;
            } else if (array.count == 2) {
                self.firstHobbyLabel.text = array[0];
                self.secondHobbyLabel.text = array[1];
                self.firstHobbyLabel.hidden = NO;
                self.secondHobbyLabel.hidden = NO;
            } else {
                self.firstHobbyLabel.text = array[0];
                self.secondHobbyLabel.text = array[1];
                self.thirdHobbyLabel.text = array[2];
                self.firstHobbyLabel.hidden = NO;
                self.secondHobbyLabel.hidden = NO;
                self.thirdHobbyLabel.hidden = NO;
            }
        }
        // 昵称
        NSMutableAttributedString *aliasString;
        if (![friendInfo.userName sy_isNullOrNil] && friendInfo.userName.length > 0) {
            aliasString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"昵称：%@",friendInfo.userName]];
            [aliasString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, aliasString.length - 3)];
        } else {
            aliasString = [[NSMutableAttributedString alloc] initWithString:@"昵称：未填写"];
            [aliasString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, aliasString.length - 3)];
        }
        self.aliasInfoLabel.attributedText = aliasString;
        // 性别
        NSMutableAttributedString *genderString;
        if (![friendInfo.userGender sy_isNullOrNil] && friendInfo.userGender.length > 0) {
            genderString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"性别：%@",friendInfo.userGender]];
            [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
        } else {
            genderString = [[NSMutableAttributedString alloc] initWithString:@"性别：未填写"];
            [genderString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, genderString.length - 3)];
        }
        self.genderInfoLabel.attributedText = genderString;
        // 年龄
        NSMutableAttributedString *ageString;
        if (![friendInfo.userAge sy_isNullOrNil] && friendInfo.userAge.length > 0) {
            ageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年龄：%@",friendInfo.userAge]];
            [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
        } else {
            ageString = [[NSMutableAttributedString alloc] initWithString:@"年龄：未填写"];
            [ageString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, ageString.length - 3)];
        }
        self.ageInfoLabel.attributedText = ageString;
        // 城市
        NSMutableAttributedString *cityString;
        if (![friendInfo.userAddress sy_isNullOrNil] && friendInfo.userAddress.length > 0) {
            cityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"城市：%@",friendInfo.userAddress]];
            [cityString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, cityString.length - 3)];
        } else {
            cityString = [[NSMutableAttributedString alloc] initWithString:@"城市：未填写"];
            [cityString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, cityString.length - 3)];
        }
//        self.cityInfoLabel.attributedText = cityString;
        // 身高
        NSMutableAttributedString *heightString;
        if (![friendInfo.userHeight sy_isNullOrNil] && friendInfo.userHeight.length > 0) {
            heightString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"身高：%@",friendInfo.userHeight]];
            [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
        } else {
            heightString = [[NSMutableAttributedString alloc] initWithString:@"身高：未填写"];
            [heightString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, heightString.length - 3)];
        }
        self.heightInfoLabel.attributedText = heightString;
        // 收入
        NSMutableAttributedString *incomeString;
        if (![friendInfo.userIncome sy_isNullOrNil] && friendInfo.userIncome.length > 0) {
            incomeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收入：%@",friendInfo.userIncome]];
            [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
        } else {
            incomeString = [[NSMutableAttributedString alloc] initWithString:@"收入：未填写"];
            [incomeString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, incomeString.length - 3)];
        }
//        self.incomeInfoLabel.attributedText = incomeString;
        // 婚姻
        NSMutableAttributedString *marrayString;
        if (![friendInfo.userMarry sy_isNullOrNil] && friendInfo.userMarry.length > 0) {
            marrayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"婚姻：%@",friendInfo.userMarry]];
            [marrayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marrayString.length - 3)];
        } else {
            marrayString = [[NSMutableAttributedString alloc] initWithString:@"婚姻：未填写"];
            [marrayString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, marrayString.length - 3)];
        }
        self.marryInfoLabel.attributedText = marrayString;
        // ID
        NSMutableAttributedString *idString;
        if (![friendInfo.userId sy_isNullOrNil] && friendInfo.userId.length > 0) {
            idString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ID：%@",friendInfo.userId]];
            [idString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, idString.length - 3)];
        } else {
            idString = [[NSMutableAttributedString alloc] initWithString:@"ID：未填写"];
            [idString addAttribute:NSForegroundColorAttributeName value:SYColor(153, 153, 153) range:NSMakeRange(3, idString.length - 3)];
        }
        self.IDInfoLabel.attributedText = idString;
        SYUser *user = self.viewModel.services.client.currentUser;
        if (user.userVipStatus == 1 && user.userVipExpiresAt != nil && ![NSDate sy_overdue:user.userVipExpiresAt]) {
            // 会员未过期
            if (friendInfo.userWechat != nil && friendInfo.userWechat.length > 0) {
                self.wxNumberLabel.text = friendInfo.userWechat;
                [self.wxNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.headerView).offset(-20);
                }];
            }
            if (friendInfo.userQq != nil && friendInfo.userQq.length > 0) {
                self.qqNumberLabel.text = friendInfo.userQq;
                [self.qqNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.headerView).offset(-20);
                }];
            }
            if (friendInfo.userMobile != nil && friendInfo.userMobile.length > 0) {
                self.mobileNumberLabel.text = friendInfo.userMobile;
                [self.mobileNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.headerView).offset(-20);
                }];
            }
        } else {
            // 未开通会员或已过期
            self.wxNumberLabel.text = @"查看微信";
            self.wxNumberLabel.userInteractionEnabled = YES;
            self.wxNumberLabel.textColor = [UIColor whiteColor];
            self.wxNumberLabel.backgroundColor = SYColorFromHexString(@"#9F69EB");
            self.wxNumberLabel.textAlignment = NSTextAlignmentCenter;
            self.wxNumberLabel.font = SYFont(12, NO);
            UITapGestureRecognizer *tapWx = [UITapGestureRecognizer new];
            [[tapWx rac_gestureSignal] subscribeNext:^(id x) {
                [self openRechargeTipsView:@"lookOver"];
            }];
            [self.wxNumberLabel addGestureRecognizer:tapWx];
            
            self.qqNumberLabel.text = @"查看QQ";
            self.qqNumberLabel.userInteractionEnabled = YES;
            self.qqNumberLabel.textColor = [UIColor whiteColor];
            self.qqNumberLabel.backgroundColor = SYColorFromHexString(@"#9F69EB");
            self.qqNumberLabel.textAlignment = NSTextAlignmentCenter;
            self.qqNumberLabel.font = SYFont(12, NO);
            UITapGestureRecognizer *tapQq = [UITapGestureRecognizer new];
            [[tapQq rac_gestureSignal] subscribeNext:^(id x) {
                [self openRechargeTipsView:@"lookOver"];
            }];
            [self.qqNumberLabel addGestureRecognizer:tapQq];
            
            self.mobileNumberLabel.text = @"查看手机号";
            self.mobileNumberLabel.userInteractionEnabled = YES;
            self.mobileNumberLabel.textColor = [UIColor whiteColor];
            self.mobileNumberLabel.backgroundColor = SYColorFromHexString(@"#9F69EB");
            self.mobileNumberLabel.textAlignment = NSTextAlignmentCenter;
            self.mobileNumberLabel.font = SYFont(12, NO);
            UITapGestureRecognizer *tapMobile = [UITapGestureRecognizer new];
            [[tapMobile rac_gestureSignal] subscribeNext:^(id x) {
                [self openRechargeTipsView:@"lookOver"];
            }];
            [self.mobileNumberLabel addGestureRecognizer:tapMobile];
        }
    }];
    [RACObserve(self.viewModel, authInfo) subscribeNext:^(SYAuthenticationModel *authInfo) {
        if (authInfo.mobileFlag == 1) {
            UIImageView *passed = [UIImageView new];
            passed.image = SYImageNamed(@"profile_icon_passed");
            [self.headerView addSubview:passed];
            [passed mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(6);
                make.bottom.right.equalTo(self.mobileImageView);
            }];
        }
        if (authInfo.selfieFlag == 3) {
            UIImageView *passed = [UIImageView new];
            passed.image = SYImageNamed(@"profile_icon_passed");
            [self.headerView addSubview:passed];
            [passed mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(6);
                make.bottom.right.equalTo(self.videoImageView);
            }];
        }
        if (authInfo.identityFlag == 3) {
            UIImageView *passed = [UIImageView new];
            passed.image = SYImageNamed(@"profile_icon_passed");
            [self.headerView addSubview:passed];
            [passed mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.offset(6);
                make.bottom.right.equalTo(self.personImageView);
            }];
        }
    }];
    _backBtn.rac_command = self.viewModel.goBackCommand;
    [[_sendMsgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.isFriend) {
            // 是好友的话直接进入单聊界面
            [[SYRCIMDataSource shareInstance] getUserInfoWithUserId:self.viewModel.userId completion:^(RCUserInfo *userInfo) {
                SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = userInfo.userId;
                conversationVC.title = userInfo.name;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }];
        } else {
            [MBProgressHUD sy_showTips:@"您与对方不是好友，请先添加对方"];
        }
    }];
    [[_sayHiBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYUser *user = self.viewModel.services.client.currentUser;
        if (user.userVipStatus == 1) {
            if (user.userVipExpiresAt != nil) {
                if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                    // 已过期
                    [self openRechargeTipsView:@"vip"];
                } else {
                    // 会员未过期再判断是否经过真人认证
                    if (user.identityStatus == 1) {
                        // 已通过真人认证
                        [[SYRCIMDataSource shareInstance] getUserInfoWithUserId:self.viewModel.userId completion:^(RCUserInfo *userInfo) {
                            SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
                            conversationVC.conversationType = ConversationType_PRIVATE;
                            conversationVC.targetId = userInfo.userId;
                            conversationVC.title = userInfo.name;
                            [self.navigationController pushViewController:conversationVC animated:YES];
                        }];
                    } else {
                        // 未通过真人认证
                        [self openRechargeTipsView:@"realAuth"];
                    }
                }
            }
        } else {
            // 未开通会员
            [self openRechargeTipsView:@"vip"];
        }
    }];
    [[_haveLookBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.isFriend) {
            SYUser *user = self.viewModel.services.client.currentUser;
            BOOL controlSwitch = NO;
            YYCache *cache = [YYCache cacheWithName:@"SeeYu"];
            if ([cache containsObjectForKey:@"controlSwitch"]) {
                // 有缓存数据优先读取缓存数据
                id value = [cache objectForKey:@"controlSwitch"];
                NSString *state = (NSString *) value;
                controlSwitch = [state isEqualToString:@"0"] ? YES : NO;
            } else {
                controlSwitch = NO;
            }
            if (controlSwitch) {
                // 不判断VIP状态
                [[RCCall sharedRCCall] startSingleCall:self.viewModel.userId mediaType:RCCallMediaVideo];
            } else {
                if (user.userVipStatus == 1) {
                    if (user.userVipExpiresAt != nil) {
                        if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                            // 已过期
                            [self openRechargeTipsView:@"vip"];
                        } else {
                            // 会员未过期,好友间可直接发起视频
                            [[RCCall sharedRCCall] startSingleCall:self.viewModel.userId mediaType:RCCallMediaVideo];
                        }
                    }
                } else {
                    // 未开通会员
                    [self openRechargeTipsView:@"vip"];
                }
            }
        } else {
            [MBProgressHUD sy_showTips:@"您与对方不是好友，请先添加对方"];
        }
    }];
    [[_addFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.enterAddFriendsViewCommand execute:self.viewModel.userId];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
//    [tableView registerClass:[SYMomentListCell class] forCellReuseIdentifier:@"momentListCell"];
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44.0;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:SYImageNamed(@"nav_btn_back") forState:UIControlStateNormal];
    _backBtn = backBtn;
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, SY_SCREEN_WIDTH + 500)];
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _headImageView = headImageView;
    [headerView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font =SYRegularFont(15);
    _aliasLabel = aliasLabel;
    [headImageView addSubview:aliasLabel];
    
    UIImageView *onlineImageView = [UIImageView new];
    _onlineImageView = onlineImageView;
    [headerView addSubview:onlineImageView];
    
    UIImageView *personImageView = [UIImageView new];
    personImageView.image = SYImageNamed(@"profile_icon_baseInfo");
    _personImageView = personImageView;
    [headerView addSubview:personImageView];
    
    UIImageView *mobileImageView = [UIImageView new];
    mobileImageView.image = SYImageNamed(@"profile_icon_mobile");
    _mobileImageView = mobileImageView;
    [headerView addSubview:mobileImageView];
    
    UIImageView *videoImageView = [UIImageView new];
    videoImageView.image = SYImageNamed(@"profile_icon_selfie");
    _videoImageView = videoImageView;
    [headerView addSubview:videoImageView];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textColor = [UIColor whiteColor];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font =SYRegularFont(13);
    _signatureLabel = signatureLabel;
    [headImageView addSubview:signatureLabel];
    
    UIView *functionView = [UIView new];
    functionView.backgroundColor = [UIColor whiteColor];
    _functionView = functionView;
    [headerView addSubview:functionView];
    
    UIButton *sendMsgBtn = [UIButton new];
    [sendMsgBtn setImage:SYImageNamed(@"profile_btn_chat") forState:UIControlStateNormal];
    _sendMsgBtn = sendMsgBtn;
    [functionView addSubview:sendMsgBtn];
    
    UILabel *sendMsgLabel = [UILabel new];
    sendMsgLabel.textColor = [UIColor blackColor];
    sendMsgLabel.textAlignment = NSTextAlignmentCenter;
    sendMsgLabel.font = SYRegularFont(15);
    sendMsgLabel.text = @"发消息";
    _sendMsgLabel = sendMsgLabel;
    [functionView addSubview:sendMsgLabel];
    
    UIButton *sayHiBtn = [UIButton new];
    [sayHiBtn setImage:SYImageNamed(@"profile_btn_sayHi") forState:UIControlStateNormal];
    _sayHiBtn = sayHiBtn;
    [functionView addSubview:sayHiBtn];
    
    UILabel *sayHiLabel = [UILabel new];
    sayHiLabel.textColor = [UIColor blackColor];
    sayHiLabel.textAlignment = NSTextAlignmentCenter;
    sayHiLabel.font = SYRegularFont(15);
    sayHiLabel.text = @"打招呼";
    _sayHiLabel = sayHiLabel;
    [functionView addSubview:sayHiLabel];
    
    UIButton *haveLookBtn = [UIButton new];
    [haveLookBtn setImage:SYImageNamed(@"profile_btn_video") forState:UIControlStateNormal];
    _haveLookBtn = haveLookBtn;
    [functionView addSubview:haveLookBtn];
    
    UILabel *haveLookLabel = [UILabel new];
    haveLookLabel.textColor = [UIColor blackColor];
    haveLookLabel.textAlignment = NSTextAlignmentCenter;
    haveLookLabel.font = SYRegularFont(15);
    haveLookLabel.text = @"看看TA";
    _haveLookLabel = haveLookLabel;
    [functionView addSubview:haveLookLabel];
    
    UIButton *addFriendBtn = [UIButton new];
    [addFriendBtn setImage:SYImageNamed(@"profile_btn_addfriend") forState:UIControlStateNormal];
    _addFriendBtn = addFriendBtn;
    [functionView addSubview:addFriendBtn];
    
    UILabel *addFriendLabel = [UILabel new];
    addFriendLabel.textColor = [UIColor blackColor];
    addFriendLabel.textAlignment = NSTextAlignmentCenter;
    addFriendLabel.font = SYRegularFont(15);
    addFriendLabel.text = @"加好友";
    _addFriendLabel = addFriendLabel;
    [functionView addSubview:addFriendLabel];
    
    UIView *lineBgView1 = [UIView new];
    lineBgView1.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _lineBgView1 = lineBgView1;
    [headerView addSubview:lineBgView1];
    
    UIView *detailInfoView = [UIView new];
    detailInfoView.backgroundColor = [UIColor whiteColor];
    _detailInfoView = detailInfoView;
    [headerView addSubview:detailInfoView];
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.text = @"信息";
    infoLabel.font = SYRegularFont(18);
    _infoLabel = infoLabel;
    [detailInfoView addSubview:infoLabel];
    
    UILabel *hobbyInfoLabel = [UILabel new];
    hobbyInfoLabel.textColor = SYColor(153, 153, 153);
    hobbyInfoLabel.textAlignment = NSTextAlignmentLeft;
    hobbyInfoLabel.font = SYRegularFont(16);
    hobbyInfoLabel.text = @"爱好";
    _hobbyInfoLabel = hobbyInfoLabel;
    [detailInfoView addSubview:hobbyInfoLabel];
    
    UILabel *firstHobbyLabel = [UILabel new];
    firstHobbyLabel.textColor = [UIColor whiteColor];
    firstHobbyLabel.layer.masksToBounds = YES;
    firstHobbyLabel.layer.cornerRadius = 10.f;
    firstHobbyLabel.backgroundColor = SYColorFromHexString(@"#9F69EB");
    firstHobbyLabel.hidden = YES;
    firstHobbyLabel.textAlignment = NSTextAlignmentCenter;
    firstHobbyLabel.font = SYRegularFont(14);
    _firstHobbyLabel = firstHobbyLabel;
    [headerView addSubview:firstHobbyLabel];
    
    UILabel *secondHobbyLabel = [UILabel new];
    secondHobbyLabel.textColor = [UIColor whiteColor];
    secondHobbyLabel.backgroundColor = SYColorFromHexString(@"#FA65E1");
    secondHobbyLabel.layer.masksToBounds = YES;
    secondHobbyLabel.layer.cornerRadius = 10.f;
    secondHobbyLabel.hidden = YES;
    secondHobbyLabel.textAlignment = NSTextAlignmentCenter;
    secondHobbyLabel.font = SYRegularFont(14);
    _secondHobbyLabel = secondHobbyLabel;
    [headerView addSubview:secondHobbyLabel];
    
    UILabel *thirdHobbyLabel = [UILabel new];
    thirdHobbyLabel.textColor = [UIColor whiteColor];
    thirdHobbyLabel.backgroundColor = SYColorFromHexString(@"#FF6768");
    thirdHobbyLabel.layer.masksToBounds = YES;
    thirdHobbyLabel.layer.cornerRadius = 10.f;
    thirdHobbyLabel.hidden = YES;
    thirdHobbyLabel.textAlignment = NSTextAlignmentCenter;
    thirdHobbyLabel.font = SYRegularFont(14);
    _thirdHobbyLabel = thirdHobbyLabel;
    [headerView addSubview:thirdHobbyLabel];
    
    UILabel *aliasInfoLabel = [UILabel new];
    aliasInfoLabel.textAlignment = NSTextAlignmentLeft;
    aliasInfoLabel.font = SYRegularFont(16);
    _aliasInfoLabel = aliasInfoLabel;
    [detailInfoView addSubview:aliasInfoLabel];
    
    UILabel *genderInfoLabel = [UILabel new];
    genderInfoLabel.textAlignment = NSTextAlignmentLeft;
    genderInfoLabel.font = SYRegularFont(16);
    _genderInfoLabel = genderInfoLabel;
    [detailInfoView addSubview:genderInfoLabel];
    
    UILabel *ageInfoLabel = [UILabel new];
    ageInfoLabel.textAlignment = NSTextAlignmentLeft;
    ageInfoLabel.font = SYRegularFont(16);
    _ageInfoLabel = ageInfoLabel;
    [detailInfoView addSubview:ageInfoLabel];
    
//    UILabel *cityInfoLabel = [UILabel new];
//    cityInfoLabel.textAlignment = NSTextAlignmentLeft;
//    cityInfoLabel.font = SYRegularFont(16);
//    _cityInfoLabel = cityInfoLabel;
//    [detailInfoView addSubview:cityInfoLabel];
    
    UILabel *heightInfoLabel = [UILabel new];
    heightInfoLabel.textAlignment = NSTextAlignmentLeft;
    heightInfoLabel.font = SYRegularFont(16);
    _heightInfoLabel = heightInfoLabel;
    [detailInfoView addSubview:heightInfoLabel];
    
//    UILabel *incomeInfoLabel = [UILabel new];
//    incomeInfoLabel.textAlignment = NSTextAlignmentLeft;
//    incomeInfoLabel.font = SYRegularFont(16);
//    _incomeInfoLabel = incomeInfoLabel;
//    [detailInfoView addSubview:incomeInfoLabel];
    
    UILabel *marryInfoLabel = [UILabel new];
    marryInfoLabel.textAlignment = NSTextAlignmentLeft;
    marryInfoLabel.font = SYRegularFont(16);
    _marryInfoLabel = marryInfoLabel;
    [detailInfoView addSubview:marryInfoLabel];
    
    UILabel *IDInfoLabel = [UILabel new];
    IDInfoLabel.textAlignment = NSTextAlignmentLeft;
    IDInfoLabel.font = SYRegularFont(16);
    _IDInfoLabel = IDInfoLabel;
    [detailInfoView addSubview:IDInfoLabel];
    
    // 微信文本
    UILabel *wxInfoLabel = [UILabel new];
    wxInfoLabel.textAlignment = NSTextAlignmentLeft;
    wxInfoLabel.font = SYRegularFont(16);
    wxInfoLabel.text = @"微信:";
    _wxInfoLabel = wxInfoLabel;
    [detailInfoView addSubview:wxInfoLabel];
    
    UILabel * wxNumberLabel = [UILabel new];
    wxNumberLabel.textColor = SYColor(153, 153, 153);
    wxNumberLabel.font = SYRegularFont(16);
    wxNumberLabel.layer.masksToBounds = YES;
    wxNumberLabel.layer.cornerRadius = 15.f;
    wxNumberLabel.textAlignment = NSTextAlignmentLeft;
    wxNumberLabel.text = @"保密";
    _wxNumberLabel = wxNumberLabel;
    [detailInfoView addSubview:wxNumberLabel];
    
    // QQ文本
    UILabel *qqInfoLabel = [UILabel new];
    qqInfoLabel.textAlignment = NSTextAlignmentLeft;
    qqInfoLabel.font = SYRegularFont(16);
    qqInfoLabel.text = @"QQ:";
    _qqInfoLabel = qqInfoLabel;
    [detailInfoView addSubview:qqInfoLabel];
    
    UILabel * qqNumberLabel = [UILabel new];
    qqNumberLabel.textColor = SYColor(153, 153, 153);
    qqNumberLabel.font = SYRegularFont(16);
    qqNumberLabel.layer.masksToBounds = YES;
    qqNumberLabel.layer.cornerRadius = 15.f;
    qqNumberLabel.textAlignment = NSTextAlignmentLeft;
    qqNumberLabel.text = @"保密";
    _qqNumberLabel = qqNumberLabel;
    [detailInfoView addSubview:qqNumberLabel];
    
    // 手机号文本
    UILabel *mobileInfoLabel = [UILabel new];
    mobileInfoLabel.textAlignment = NSTextAlignmentLeft;
    mobileInfoLabel.font = SYRegularFont(16);
    mobileInfoLabel.text = @"手机号:";
    _mobileInfoLabel = mobileInfoLabel;
    [detailInfoView addSubview:mobileInfoLabel];
    
    UILabel * mobileNumberLabel = [UILabel new];
    mobileNumberLabel.textColor = SYColor(153, 153, 153);
    mobileNumberLabel.font = SYRegularFont(16);
    mobileNumberLabel.layer.masksToBounds = YES;
    mobileNumberLabel.layer.cornerRadius = 15.f;
    mobileNumberLabel.textAlignment = NSTextAlignmentLeft;
    mobileNumberLabel.text = @"保密";
    _mobileNumberLabel = mobileNumberLabel;
    [detailInfoView addSubview:mobileNumberLabel];
    
    UIView *lineBgView2 = [UIView new];
    lineBgView2.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _lineBgView2 = lineBgView2;
    [headerView addSubview:lineBgView2];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.width.height.offset(30);
        make.top.equalTo(self.view).offset(SY_APPLICATION_STATUS_BAR_HEIGHT);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.headerView);
        make.height.offset(SY_SCREEN_WIDTH);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.signatureLabel);
        make.bottom.equalTo(self.signatureLabel.mas_top).offset(-15);
    }];
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel.mas_right);
        make.width.offset(40);
        make.height.offset(15);
        make.centerY.equalTo(self.aliasLabel);
    }];
    [self.personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.mobileImageView);
        make.right.equalTo(self.mobileImageView.mas_left).offset(-15);
    }];
    [self.mobileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.videoImageView);
        make.right.equalTo(self.videoImageView.mas_left).offset(-15);
    }];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(14);
        make.centerY.equalTo(self.onlineImageView);
        make.right.equalTo(self.headerView).offset(-15);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.right.equalTo(self.headerView).offset(-20);
        make.height.offset(15);
        make.bottom.equalTo(self.headImageView).offset(-15);
    }];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.headerView);
        make.top.equalTo(self.headImageView.mas_bottom);
        make.bottom.equalTo(self.sendMsgLabel).offset(15);
    }];
    CGFloat margin = (SY_SCREEN_WIDTH - 50 * 4 - 60) / 3;
    [self.sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(50);
        make.left.equalTo(self.functionView).offset(30);
        make.top.equalTo(self.functionView).offset(15);
    }];
    [self.sendMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendMsgBtn.mas_bottom).offset(5);
        make.height.offset(15);
        make.width.centerX.equalTo(self.sendMsgBtn);
    }];
    [self.sayHiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.sendMsgBtn);
        make.left.equalTo(self.sendMsgBtn.mas_right).offset(margin);
    }];
    [self.sayHiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.sendMsgLabel);
        make.centerX.equalTo(self.sayHiBtn);
    }];
    [self.haveLookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.sayHiBtn);
        make.left.equalTo(self.sayHiBtn.mas_right).offset(margin);
    }];
    [self.haveLookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.sayHiLabel);
        make.centerX.equalTo(self.haveLookBtn);
    }];
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.haveLookBtn);
        make.left.equalTo(self.haveLookBtn.mas_right).offset(margin);
    }];
    [self.addFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.sendMsgLabel);
        make.centerX.equalTo(self.addFriendBtn);
    }];
    [self.lineBgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionView.mas_bottom);
        make.height.offset(15);
        make.left.width.equalTo(self.functionView);
    }];
    [self.detailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.lineBgView1);
        make.top.equalTo(self.lineBgView1.mas_bottom);
        make.bottom.equalTo(self.mobileInfoLabel).offset(15);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.detailInfoView).offset(15);
        make.right.equalTo(self.detailInfoView).offset(-15);
        make.height.offset(20);
    }];
    [self.hobbyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(30);
        make.left.equalTo(self.infoLabel);
        make.width.offset(50);
    }];
    [self.firstHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hobbyInfoLabel.mas_right);
        make.width.offset(65);
        make.height.offset(20);
        make.centerY.equalTo(self.hobbyInfoLabel);
    }];
    [self.secondHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstHobbyLabel.mas_right).offset(15);
        make.centerY.width.height.equalTo(self.firstHobbyLabel);
    }];
    [self.thirdHobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondHobbyLabel.mas_right).offset(15);
        make.centerY.width.height.equalTo(self.secondHobbyLabel);
    }];
    [_aliasInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(SY_SCREEN_WIDTH / 2 - 15);
        make.top.equalTo(self.hobbyInfoLabel.mas_bottom).offset(30);
        make.left.equalTo(self.hobbyInfoLabel);
    }];
    [_genderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.aliasInfoLabel);
        make.right.equalTo(self.detailInfoView).offset(-15);
    }];
    [_ageInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasInfoLabel.mas_bottom).offset(30);
        make.left.width.height.equalTo(self.aliasInfoLabel);
    }];
    [_marryInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.ageInfoLabel);
        make.right.equalTo(self.detailInfoView).offset(-15);
    }];
    [_heightInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageInfoLabel.mas_bottom).offset(30);
        make.left.width.height.equalTo(self.aliasInfoLabel);
    }];
    [_IDInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.heightInfoLabel);
        make.right.equalTo(self.detailInfoView).offset(-15);
    }];
    [_wxInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heightInfoLabel.mas_bottom).offset(30);
        make.left.width.height.equalTo(self.aliasInfoLabel);
    }];
    [_wxNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wxInfoLabel);
        make.left.equalTo(self.detailInfoView).offset(SY_SCREEN_WIDTH / 2);
        make.height.offset(30);
        make.width.offset(80);
    }];
    [_qqInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wxInfoLabel.mas_bottom).offset(30);
        make.left.width.height.equalTo(self.aliasInfoLabel);
    }];
    [_qqNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qqInfoLabel);
        make.left.equalTo(self.detailInfoView).offset(SY_SCREEN_WIDTH / 2);
        make.height.offset(30);
        make.width.offset(80);
    }];
    [_mobileInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qqInfoLabel.mas_bottom).offset(30);
        make.left.width.height.equalTo(self.aliasInfoLabel);
    }];
    [_mobileNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mobileInfoLabel);
        make.left.equalTo(self.detailInfoView).offset(SY_SCREEN_WIDTH / 2);
        make.height.offset(30);
        make.width.offset(80);
    }];
    [_lineBgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailInfoView.mas_bottom);
        make.height.offset(15);
        make.left.width.equalTo(self.functionView);
    }];
}

#pragma  mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"momentListCell"];
    }
    return cell;
}

// 打开权限弹窗
- (void)openRechargeTipsView:(NSString *)type {
    SYPopViewVM *popVM = [[SYPopViewVM alloc] initWithServices:self.viewModel.services params:nil];
    popVM.type = type;
    SYPopViewVC *popVC = [[SYPopViewVC alloc] initWithViewModel:popVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:popVC withAnimation:animation];
}

@end
