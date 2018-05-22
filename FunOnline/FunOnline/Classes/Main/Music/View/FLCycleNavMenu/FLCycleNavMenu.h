//
//  FLCycleNavMenu.h
//  FunOnline
//
//  Created by Original_TJ on 2018/5/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

typedef void(^BackDidFinishedBlock)(void);

@interface FLCycleNavMenu : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *leftImage;
@property (nonatomic, copy) NSString *rightImage;

@property (nonatomic, assign) BOOL hideLine;
@property (nonatomic, strong) AlbumModel *item;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) BackDidFinishedBlock backDidFinishedBlock;

@end
