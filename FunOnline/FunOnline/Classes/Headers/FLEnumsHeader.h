//
//  FLEnumsHeader.h
//  FunOnline
//
//  Created by Mac on 2018/5/3.
//  Copyright © 2018年 iOS. All rights reserved.
//

#ifndef FLEnumsHeader_h
#define FLEnumsHeader_h

/**
 播放模式
 
 - PlayingModeAllLoopPlay: 循环播放
 - PlayingModeSingleLoop: 单曲循环
 - PlayingModeRandomPlay: 随机播放
 */
typedef enum {
    PlayingModeAllLoopPlay,
    PlayingModeSingleLoop,
    PlayingModeRandomPlay
}PlayingMode; //播放模式


/**
 播放状态控制
 
 - PlayerBackStatePlay: 播放
 - PlayerBackStatePause: 暂停
 */
typedef enum {
    PlayerBackStatePlay,
    PlayerBackStatePause,
}PlayerBackState;


/**
 播放控制

 - PlayClickEventAlbum: 点击头像
 - PlayClickEventPrev: 上一曲
 - PlayClickEventNext: 下一曲
 */
typedef NS_ENUM(NSUInteger, PlayClickEvent){
    PlayClickEventAlbum = 1000,
    PlayClickEventPrev,
    PlayClickEventNext
};


#endif /* FLEnumsHeader_h */
