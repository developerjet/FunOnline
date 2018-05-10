//
//  BannerHeaderView.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BannerHeaderView.h"
#import <SDCycleScrollView.h>

@interface BannerHeaderView()<SDCycleScrollViewDelegate>
/** 轮播器 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation BannerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"icon_banner_placeholder"]];
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor colorThemeColor];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [self addSubview:_cycleScrollView];
    }
    return self;
}


#pragma mark - Setter

- (void)setBannerModelGroup:(NSArray *)bannerModelGroup {
    
    _bannerModelGroup = bannerModelGroup;
    
    NSMutableArray *newURLStringGroup = [NSMutableArray new];
    [bannerModelGroup enumerateObjectsUsingBlock:^(BannerModel *object, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([object isKindOfClass:[BannerModel class]]) {
            
            [newURLStringGroup addObject:object.thumb];
        };
    }];
    
    
    if (newURLStringGroup.count)
    {
        [self.cycleScrollView setImageURLStringsGroup:newURLStringGroup];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cycleScrollView.frame = self.bounds;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didSelectIndexAtItem:)]) {
        
        [self.delegate banner:self didSelectIndexAtItem:self.bannerModelGroup[index]];
    }
}

@end
