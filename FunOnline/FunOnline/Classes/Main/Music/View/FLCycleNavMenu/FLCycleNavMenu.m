//
//  FLCycleNavMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/5/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FLCycleNavMenu.h"

static CGFloat kDefaultHeight = 64.f; //导航栏高度
static CGFloat kIphoneXHeight = 88.f; //导航栏高度

@interface FLCycleNavMenu()

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel  *titleLabel;

@end

@implementation FLCycleNavMenu

#pragma mark - init method

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat height = iPhoneX ? kIphoneXHeight : kDefaultHeight;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.hidden = YES;
    [_leftButton setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(backDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rightButton];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.hidden = YES;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"欢迎来到FunOline";
    _titleLabel.textColor = [UIColor colorWhiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
}

- (void)backDidEvent:(UIButton *)sender {
    
    if (self.backDidFinishedBlock) {
        self.backDidFinishedBlock();
    }
}

#pragma mark - Setter

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

- (void)setShowTools:(BOOL)showTools {
    _showTools = showTools;
    
    self.leftButton.hidden = !showTools;
    self.titleLabel.hidden = !showTools;
}

- (void)setItem:(AlbumModel *)item {
    _item = item;
    
    self.titleLabel.text = item.title;
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
    
    CGFloat titleWidth = 200.f;
    CGFloat titleX = (self.frame.size.width-titleWidth)/2;
    self.titleLabel.frame  = CGRectMake(titleX, btnY, titleWidth, btnWH);
}


@end
