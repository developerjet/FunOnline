//
//  MusicPlayerViewController.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayModel.h"

@class MusicPlayerViewController;

@protocol MusicPlayerControllerDelegate<NSObject>
@optional
- (void)player:(MusicPlayerViewController *)player DidPlaySongAtIndex:(NSInteger)index;
- (void)player:(MusicPlayerViewController *)player DidPlayerAtState:(PlayerBackState)state;

@end


@interface MusicPlayerViewController : UIViewController

/** 初次展示 */
- (void)show;
/** 隐藏播放 */
- (void)dismiss;
/** 重新显示 */
- (void)redisShow;
/** 开始(继续)播放 */
- (void)startPlay;
/** 暂停(当前)播放 */
- (void)stopPlay;
/** 刷新播放信息 */
- (void)reloadPlayer;

/** 上一首 */
- (void)prevPlay;
/** 下一首 */
- (void)nextPlay;

/** 所有的播放资源 */
@property (nonatomic, assign) NSArray *playObjects;
/** 当前播放索引 */
@property (nonatomic, assign) NSInteger playingIndex;
/** 音乐播放模式 */
@property (nonatomic, assign) PlayingMode playMode;
/** 音乐播放状态(播放&暂停) */
@property (nonatomic, assign) PlayerBackState playState;
/** 设置代理 */
@property (nonatomic, weak) id<MusicPlayerControllerDelegate> delegate;

@end
