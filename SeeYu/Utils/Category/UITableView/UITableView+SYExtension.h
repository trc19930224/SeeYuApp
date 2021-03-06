//
//  UITableView+SYExtension.h
//  WeChat
//
//  Created by senba on 2017/5/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (SYExtension)
/**
 * 使用以下两个方法注册的cell，identifier和类名保持一致
 * 推荐使用类名做cell的标识符
 * 使用该方法获取identifier字符串：
 * NSString *identifier = NSStringFromClass([UITableViewCell class])
 */
- (void)sy_registerCell:(Class)cls;
- (void)sy_registerNibCell:(Class)cls;

- (void)sy_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)sy_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;

@end
