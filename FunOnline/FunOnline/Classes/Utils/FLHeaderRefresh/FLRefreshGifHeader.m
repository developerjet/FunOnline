//
//  FLRefreshHeader.m
//  FunOnline
//
//  Created by Mac on 2018/5/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FLRefreshGifHeader.h"

@implementation FLRefreshGifHeader

#pragma mark - 重写父类方法（基本设置）

- (void)prepare
{
    [super prepare];
    
    // 隐藏设置
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.automaticallyChangeAlpha = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=50; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 50; i<=77; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [refreshingImages addObject:newImage];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    NSMutableArray *startImages = [NSMutableArray array];
    //    for (NSUInteger i = 50; i<= 75; i++) {
    //        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
    //        UIImage *image = [UIImage imageNamed:imageName];
    //        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
    //        [startImages addObject:newImage];
    //    }
    for (NSUInteger i = 77; i<= 95; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [startImages addObject:newImage];
    }
    
    // 设置正在刷新状态的动画图片
    [self setImages:startImages forState:MJRefreshStateRefreshing];
}


@end
