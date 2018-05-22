//
//  InfiniteCarouselMenu.h
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@class FLCycleCarouselView;
@protocol InfiniteCarouselDelegate<NSObject>

@optional
- (void)carousel:(FLCycleCarouselView *)carousel didSelectItemAtModel:(BannerModel *)model;

@end

@interface FLCycleCarouselView : UIView

/** 预览图片名称 */
@property (nonatomic, strong) NSString *placeholder;

/** 圆角边距设置 */
@property (nonatomic, assign) NSInteger cornerRadius;

/** 自动滚动间隔时间 */
@property (nonatomic, assign) CGFloat autoScrollTime;

/** 点击监听 */
@property (nonatomic, copy) void(^clickItemOperationBlock)(BannerModel *model);

/** 滚动监听 */
@property (nonatomic, copy) void(^itemDidScrollOperationBlock)(NSInteger index);

/** 轮播数据 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 设置代理 */
@property (nonatomic, weak) id<InfiniteCarouselDelegate> delegate;

@end
