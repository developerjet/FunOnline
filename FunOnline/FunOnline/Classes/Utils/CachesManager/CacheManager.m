//
//  CacheManager.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/22.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CacheManager.h"
#import <SDWebImageManager.h>
#import "WallPaperModel.h"
#import "NewsModel.h"

#define kCacheImage [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"images.plist"]

#define kCacheNews [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"news.plist"]

@implementation CacheManager
{
    NSMutableArray *_imageStarGroup;
    NSMutableArray *_newsStarGroup;
}

+ (instancetype)sharedManager {
    static CacheManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[CacheManager alloc] init];
    });
    return _shared;
}


- (NSMutableArray *)imageStarGroup {
    
    if (_imageStarGroup == nil)
    {
        _imageStarGroup = [NSKeyedUnarchiver unarchiveObjectWithFile:kCacheImage];
        
        if (_imageStarGroup == nil)
        {
            _imageStarGroup = [NSMutableArray array];
        }
    }
    return _imageStarGroup;
}


- (NSMutableArray *)newsStarGroup {
    
    if (_newsStarGroup == nil) {
        
        _newsStarGroup = [NSKeyedUnarchiver unarchiveObjectWithFile:kCacheNews];
        
        if (_newsStarGroup == nil) {
            
            _newsStarGroup = [NSMutableArray array];
        }
    }
    return _newsStarGroup;
}

#pragma mark - ======================== 图片收藏 ========================

- (void)startNewPictureWithModel:(WallPaperModel *)model {
    if (!model) return;
    
    [self.imageStarGroup removeObject:model];
    [self.imageStarGroup insertObject:model atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.imageStarGroup toFile:kCacheImage];
}

- (void)unstartPictureWithModel:(WallPaperModel *)model
{   
    [[CacheManager sharedManager].imageStarGroup enumerateObjectsUsingBlock:^(WallPaperModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([model.Id isEqualToString:obj.Id]) {
            
            [self.imageStarGroup removeObject:obj];
        }
    }];
    
    [NSKeyedArchiver archiveRootObject:self.imageStarGroup toFile:kCacheImage];
}

- (BOOL)isStartPictureWithModel:(WallPaperModel *)model {
    if (!model) return NO;
    
    __block BOOL isStar = NO;
    [self.imageStarGroup enumerateObjectsUsingBlock:^(WallPaperModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([model.Id isEqualToString:obj.Id]) {
         
            isStar = obj.isStar;
        }
    }];
    return isStar;
}


#pragma mark - ======================== 新闻收藏 ========================

- (void)startNewsWithModel:(NewsModel *)model {
    if (!model) return;
    
    [self.newsStarGroup removeObject:model];
    [self.newsStarGroup insertObject:model atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.newsStarGroup toFile:kCacheNews];
}

- (void)unStartNewsWithModel:(NewsModel *)model {
    if (!model) return;
    
    [[CacheManager sharedManager].newsStarGroup enumerateObjectsUsingBlock:^(NewsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([model.newsId isEqualToString:obj.newsId]) {
            
            [self.newsStarGroup removeObject:obj];
        }
    }];
    
    [NSKeyedArchiver archiveRootObject:self.newsStarGroup toFile:kCacheImage];
}

- (BOOL)isStartNewsWithModel:(NewsModel *)model {
    if (!model) return NO;
    
    __block BOOL isStar = NO;
    [self.newsStarGroup enumerateObjectsUsingBlock:^(NewsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([model.newsId isEqualToString:obj.newsId]) {
            
            isStar = obj.isStar;
        }
    }];
    return isStar;
}


#pragma mark - ======================== 快速登录处理 ========================

- (BOOL)isLogon {
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UD_LOGON_ISEXIT] boolValue];
}


#pragma mark - 图片缓存管理

- (NSString *)cacheSize {
    NSInteger caches = [[SDImageCache sharedImageCache] getSize];
    
    if (caches) {
        if (caches>1024.0*1024.0) {
            return [NSString stringWithFormat:@"当前缓存 %.2fMB", caches/1024.0/1024.0];
        }else if (caches>1024.0) {
            return [NSString stringWithFormat:@"当前缓存 %.2fKB", caches/1024.0];
        }else if (caches>0) {
            return [NSString stringWithFormat:@"当前缓存 %.2luB", caches];
        }
    }
    return @"当前缓存 0KB";
}

- (void)clearCache
{    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}


@end
