//
//  MusicPlaylistMenu.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayModel.h"

@class MusicPlayingMenu;

@protocol MusicPlayMenuDelegate<NSObject>
@optional
- (void)menu:(MusicPlayingMenu *)menu DidSelectPlayingAtIndex:(NSInteger)index;

@end

@interface MusicPlayingMenu : UIView

/** 初始化播放列表 */
- (instancetype)initPlayingWithDelegate:(id<MusicPlayMenuDelegate>)delegate
                           playingGroup:(NSArray *)playingGroup;

/** 显示列表 */
- (void)show;
/** 隐藏(移除列表) */
- (void)dismiss;

/** 代理设置 */
@property (nonatomic, weak) id<MusicPlayMenuDelegate> delegate;
/** 当前播放的歌曲索引 */
@property (nonatomic, assign) NSInteger playingIndex;

@end
