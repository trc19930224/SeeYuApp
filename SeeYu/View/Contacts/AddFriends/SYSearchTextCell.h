//
//  SYSearchTextCell.h
//  WeChat
//
//  Created by senba on 2018/2/28.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  显示搜索

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"
@interface SYSearchTextCell : UITableViewCell<SYReactiveView>
/// init
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
