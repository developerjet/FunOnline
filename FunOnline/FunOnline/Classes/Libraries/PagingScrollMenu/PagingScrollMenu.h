//
//  PagingDropView.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PagingScrollMenu;

typedef void(^ScrollDidBlock)(NSInteger index);

@protocol PagingScrollMenuDelegate<NSObject>
@optional
- (void)scroll:(PagingScrollMenu *)scroll didSelectItemAtIndex:(NSInteger)index;

@end

@interface PagingScrollMenu : UIView

- (instancetype)initWithOrigin:(CGPoint)origin
                        height:(CGFloat)height
                        titles:(NSArray *)titles;

- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
                        height:(CGFloat)height
                        titles:(NSArray *)titles;

/** 滚动到指定位置(并选中) */
- (void)scrollToAtIndex:(NSInteger)index;
/** 隐藏底部分割线(默认显示) */
@property (nonatomic, assign) BOOL hideLine;
/** 获取滚动的索引位置 */
@property (nonatomic, copy) ScrollDidBlock scrollDidBlock;

@property (nonatomic, weak) id<PagingScrollMenuDelegate> delegate;

@property (nonatomic, assign) CGPoint scrollPoint;

@end
