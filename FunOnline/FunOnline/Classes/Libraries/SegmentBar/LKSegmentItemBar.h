//
//  LKMainTopView.h
//  LinekeLive
//
//  Created by CODER_TJ on 2017/6/24.
//  Copyright © 2017年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidFinishedBlock)(NSInteger index);

@class LKSegmentItemBar;

@protocol LKSegmentItemBarDelegate<NSObject>
@optional
- (void)segment:(LKSegmentItemBar *)segment DidSelectItemAtIndex:(NSInteger)index;

@end

@interface LKSegmentItemBar : UIView

- (instancetype)initWithFrame:(CGRect)frame segmentItems:(NSArray *)items;

- (void)scrolling:(NSInteger)index;

/** 点击菜单标题的回调 */
@property (nonatomic, copy) DidFinishedBlock didFinishedBlock;
/** 菜单栏主题颜色设置(默认白色) */
@property (nonatomic, strong) UIColor *tintColor;
/** 关闭点击水波纹动画(默认开启) */
@property (nonatomic, assign) BOOL isAnima;
/** 设置代理 */
@property (nonatomic, weak) id<LKSegmentItemBarDelegate> delegate;

@end
