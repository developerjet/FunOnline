//
//  MusicPlayBar.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayModel.h"

@class MusicPlayManagerBar;

@protocol MusicPlayBarDelegate<NSObject>
@optional
- (void)play:(MusicPlayManagerBar *)play DidPlayAtState:(PlayClickEvent)event;

- (void)play:(MusicPlayManagerBar *)play DidPlayOrPause:(PlayerBackState)state;

@end

@interface MusicPlayManagerBar : UIView

- (instancetype)initWithOrigin:(CGPoint)origin
                         plays:(NSArray *)plays;

- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
                        height:(CGFloat)height
                        plays:(NSArray *)plays;

- (void)show;
- (void)dismiss;
- (void)remover;

- (void)startRotaAnima;
- (void)stopRotaAnima;
- (void)resumeRotaAnima;

/** 刷新歌曲播放信息 */
- (void)reloadPlayer:(MusicPlayModel *)mode;
/** 播放索引 */
@property (nonatomic, assign) NSInteger playingIndex;
/** 当前播放状态 */
@property (nonatomic, assign) PlayerBackState state;
/** 代理设置 */
@property (nonatomic, weak) id<MusicPlayBarDelegate> delegate;

@end
