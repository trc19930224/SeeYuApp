//
//  SYMomentsEditVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMomentsEditVM : SYVM

/* 视频/相册 */
@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) BOOL cellIsFull;

/* 动态文本 */
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSURL *videoContentUrl;

@property (nonatomic, strong) NSArray<UIImage *> *imagesArray;

@property (nonatomic, strong) NSArray<PHAsset *> *assetArray;

@property (nonatomic, strong) RACCommand *releaseMomentCommand;

@property (nonatomic, strong) RACCommand *releaseVideoFromAlbumCommand;

@end

NS_ASSUME_NONNULL_END
