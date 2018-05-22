//
//  InfiniteCarouselMenu.m
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FLCycleCarouselView.h"
#import <iCarousel/iCarousel.h>

#define PAGE_OFFSET 10

@interface FLCycleCarouselView()<iCarouselDelegate, iCarouselDataSource>

/** 3D轮播容器 */
@property (nonatomic, strong) iCarousel *carousel;
/** 网络图片数据 */
@property (nonatomic, strong) NSMutableArray *imagesGroup;

@end


@implementation FLCycleCarouselView

#pragma mark - Lazy

- (NSMutableArray *)imagesGroup {
    
    if (!_imagesGroup) {
        
        _imagesGroup = [[NSMutableArray alloc] init];
    }
    return _imagesGroup;
}

- (iCarousel *)carousel {
    
    if (!_carousel) {
        _carousel = [[iCarousel alloc] init];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.autoscroll = 0.2;
        _carousel.type = iCarouselTypeCustom;
    }
    return _carousel;
}

#pragma mark - Initiali

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self configCarousel];
    }
    return self;
}

- (void)configCarousel
{
    [self addSubview:self.carousel];
    [self.carousel reloadData];
}

#pragma mark - Private setter

- (void)setAutoScrollTime:(CGFloat)autoScrollTime {
    _autoScrollTime = autoScrollTime;
    
    if (autoScrollTime <= 0) {
        self.carousel.autoscroll = 0.2;
    }
    self.carousel.autoscroll = autoScrollTime;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    if (self.imagesGroup.count) {
        [self.imagesGroup removeAllObjects];
    }
    
    [self.imagesGroup addObjectsFromArray:self.imageURLStringsGroup];
    [self.carousel reloadData];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - iCarouselDelegate && iCarouselDataSource
// 返回多少行/列
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.imagesGroup.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat viewWidth = SCREEN_WIDTH - 2*PAGE_OFFSET;
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.tj_height)];
        view.backgroundColor = [UIColor clearColor];
    }
    
    if (self.imagesGroup.count > index) { //防止越界
        BannerModel *model = self.imagesGroup[index];
        [((UIImageView *)view) HT_setImageWithCornerRadius:self.cornerRadius imageURL:[NSURL URLWithString:model.pic] placeholder:self.placeholder contentMode:UIViewContentModeScaleToFill size:CGSizeMake(viewWidth, self.tj_height)];
    }
    return view;
}

//自定义动画效果
-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.2, 0.0, 0.0);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (self.imagesGroup.count > index) {
        BannerModel *model = self.imagesGroup[index];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(carousel:didSelectItemAtModel:)]) {
            [self.delegate carousel:self didSelectItemAtModel:model];
        }
        
        if (self.clickItemOperationBlock) {
            self.clickItemOperationBlock(model);
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(self.carousel.currentItemIndex);
    }
}

#pragma mark - dealloc

- (void)dealloc {
    
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;
}

@end
