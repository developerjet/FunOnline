//
//  CacheManager.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/22.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WallpaperModel, NewsModel;
@interface CacheManager : NSObject

/**
 *  单例
 */
+ (instancetype)sharedManager;

// ======================== 图片收藏 ======================== //

/**
 *  收藏当前图片
 */
- (void)startNewPictureWithModel:(WallpaperModel *)model;

/**
 *  取消当前图片收藏
 */
- (void)unstartPictureWithModel:(WallpaperModel *)model;

/**
 *  图片是否已经收藏
 */
- (BOOL)isStartPictureWithModel:(WallpaperModel *)model;

/**
 * 图片所有的收藏数据
 */
@property (nonatomic, strong) NSMutableArray *imageStarGroup;


// ======================== 新闻收藏 ======================== //

/**
 *  收藏当前新闻
 */
- (void)startNewsWithModel:(NewsModel *)model;

/**
 *  取消当前新闻收藏
 */
- (void)unStartNewsWithModel:(NewsModel *)model;

/**
 *  图片是否已经收藏
 */
- (BOOL)isStartNewsWithModel:(NewsModel *)model;

/**
 * 新闻所有的收藏数据
 */
@property (nonatomic, strong) NSMutableArray *newsStarGroup;



#pragma mark - ***************** 登录管理 *****************

/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogon;

@end
