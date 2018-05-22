//
//  FLCycleNavMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/5/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FLCycleNavMenu.h"

static CGFloat kDefaultHeight = 64.f; //常用导航栏高度
static CGFloat kIphoneXHeight = 88.f; //iPhoneX导航栏高度

@interface FLCycleNavMenu()

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIView   *lineView;

@end

@implementation FLCycleNavMenu

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat height = iPhoneX ? kIphoneXHeight : kDefaultHeight;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.backgroundColor = [[UIColor colorThemeColor] colorWithAlphaComponent:0.f];
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(backDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rightButton];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWhiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.hidden = YES; //默认隐藏
    _lineView.backgroundColor = [UIColor colorLightTextColor];
    [self addSubview:_lineView];
}

- (void)backDidEvent:(UIButton *)sender {
    
    if (self.backDidFinishedBlock) {
        self.backDidFinishedBlock();
    }
}

#pragma mark - Private setter

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setLeftImage:(NSString *)leftImage {
    _leftImage = leftImage;
    
    [self.leftButton setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
}

- (void)setRightImage:(NSString *)rightImage {
    _rightImage = rightImage;
    
    [self.rightButton setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    self.titleLabel.textColor = titleColor;
}

- (void)setItem:(AlbumModel *)item {
    _item = item;
    
    self.titleLabel.text = item.title;
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    
    self.lineView.hidden = hideLine;
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spaec = 20;
    CGFloat btnWH = 22.0f;
    CGFloat btnY  = ((self.frame.size.height - btnWH) / 2) + 10;
    
    self.leftButton.frame  = CGRectMake(spaec, btnY, btnWH, btnWH);
    
    CGFloat rightX = self.frame.size.width - btnWH - spaec;
    self.rightButton.frame = CGRectMake(rightX, btnY, btnWH, btnWH);
    
    CGFloat titleW = 200.f;
    CGFloat titleX = (self.frame.size.width-titleW)/2;
    self.titleLabel.frame  = CGRectMake(titleX, btnY, titleW, btnWH);
    
    CGFloat lineY = self.frame.size.height - 0.25;
    self.lineView.frame = CGRectMake(0, lineY, SCREEN_WIDTH, 0.25);
}


@end

