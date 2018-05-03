//
//  BannerHeaderView.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@class BannerHeaderView;
@protocol BannerHeaderViewDelegate<NSObject>
@optional
- (void)banner:(BannerHeaderView *)banner didSelectIndexAtItem:(BannerModel *)item;

@end

@interface BannerHeaderView : UICollectionReusableView

/** 轮播模型数组 */
@property (nonatomic, strong) NSArray *bannerModelGroup;
/** 代理 */
@property (nonatomic, weak) id<BannerHeaderViewDelegate> delegate;

@end
