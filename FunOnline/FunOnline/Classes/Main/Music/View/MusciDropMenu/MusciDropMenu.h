//
//  MusciDropMenu.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

typedef void(^BackDidFinishedBlock)(void);

@interface MusciDropMenu : UIView

/** 模型数据 */
@property (nonatomic, strong) AlbumModel *album;
/** 返回回调 */
@property (nonatomic, copy) BackDidFinishedBlock backDidBlock;

@end
