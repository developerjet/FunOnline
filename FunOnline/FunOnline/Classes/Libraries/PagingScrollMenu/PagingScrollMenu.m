//
//  PagingDropView.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "PagingScrollMenu.h"

@interface PagingScrollMenu()
/** 可滚动容器 */
@property (nonatomic, strong) UIScrollView *pageScrollView;
/** 保存所有的按钮 */
@property (nonatomic, strong) NSMutableArray *buttonObjects;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleObjects;
/** 记录选中的按钮 */
@property (nonatomic, strong) UIButton *selectedBtn;
/** 底部分割线 */
@property (nonatomic, strong) UIView *menuLineView;

@end


@implementation PagingScrollMenu

#pragma mark - init

- (NSMutableArray *)buttonObjects
{
    if (!_buttonObjects) {
        
        _buttonObjects = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonObjects;
}

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height titles:(NSArray *)titles
{
    return [self initWithOrigin:origin width:[UIScreen mainScreen].bounds.size.width height:height titles:titles];
}

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width height:(CGFloat)height titles:(NSArray *)titles {

    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, height)]) {
        
        if (titles && titles.count) {
            self.titleObjects = titles;
            [self configPageScroll];
        }
    }
    return self;
};


- (void)configPageScroll
{
    CGFloat originW = 80;
    CGFloat line_height = 0.5;
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height - line_height)];
    self.pageScrollView.contentSize = CGSizeMake(self.titleObjects.count * originW, 0);
    [self addSubview:self.pageScrollView];
    
    CGFloat line_originY = CGRectGetMaxY(self.pageScrollView.frame);
    self.menuLineView = [[UIView alloc] initWithFrame:CGRectMake(0, line_originY, SCREEN_WIDTH, line_height)];
    self.menuLineView.hidden = NO; // 默认显示
    self.menuLineView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [self addSubview:self.menuLineView];
    
    CGFloat originH = 30;
    CGFloat originY = (self.pageScrollView.frame.size.height - originH) * 0.5;
    
    CGFloat space = 5;
    for (NSInteger idx = 0; idx < self.titleObjects.count; idx++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(idx * originW + space , originY, originW, originH);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:self.titleObjects[idx] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorThemeColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorLightTextColor] forState:UIControlStateNormal];
        [self.pageScrollView addSubview:button];
        button.tag = idx + 1000; //绑定tag值
        [button addTarget:self action:@selector(pagingScrollEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonObjects addObject:button];
        
        if (idx == 0) {
            button.selected  = YES;
            self.selectedBtn = button;
        }
    }
}

#pragma mark - Getter && Setter

- (CGPoint)scrollPoint {
    
    return self.pageScrollView.contentOffset;
}

- (void)setHideLine:(BOOL)hideLine {
    
    _hideLine = hideLine;
    
    self.menuLineView.hidden = hideLine;
}

#pragma mark - scroll action

- (void)scrollToAtIndex:(NSInteger)index {
    UIButton *button = self.buttonObjects[index];
    _selectedBtn.selected = NO;
    
    button.selected = YES;
    _selectedBtn = button;
    
    [self animaScrolling:button];
}

- (void)pagingScrollEvent:(UIButton *)button {
    if (button.selected) return;
    
    _selectedBtn.selected = !_selectedBtn.selected;
    _selectedBtn = button;
    
    button.selected = !button.selected;
    [self animaScrolling:button];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroll:didSelectItemAtIndex:)]) {
        
        [self.delegate scroll:self didSelectItemAtIndex:button.tag - 1000];
    }
    
    if (self.scrollDidBlock) {
        self.scrollDidBlock(button.tag - 1000);
    }
}

- (void)animaScrolling:(UIButton *)button {
    
    [UIView animateWithDuration:0.25 animations:^{
        float offsetX = CGRectGetMinX(button.frame);
        
        if (offsetX < SCREEN_WIDTH/2) {
            [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (offsetX >= SCREEN_WIDTH/2 && offsetX <= self.pageScrollView.contentSize.width - SCREEN_WIDTH/2) {
            [self.pageScrollView setContentOffset:CGPointMake(offsetX - SCREEN_WIDTH/2, 0) animated:YES];
        }else{ //加上button.width，防止点击产生遮挡
            [self.pageScrollView setContentOffset:CGPointMake(((self.pageScrollView.contentSize.width - SCREEN_WIDTH) + button.frame.size.width), 0) animated:YES];
        }
    }];
}

@end
