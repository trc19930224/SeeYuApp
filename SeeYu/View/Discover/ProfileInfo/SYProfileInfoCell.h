//
//  SYProfileInfoCell.h
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"

@interface SYProfileInfoCell : UITableViewCell<SYReactiveView>

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
