//
//  SearchDropMenu.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "SearchDropMenu.h"

@implementation SearchDropMenu

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        
        self.hidden = YES; // 默认隐藏
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor colorThemeColor];
    [self addSubview:_titleLabel];
    
    _cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cleanButton setImage:[UIImage imageNamed:@"search_clear"] forState:UIControlStateNormal];
    [_cleanButton addTarget:self action:@selector(cleanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cleanButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initConstraints];
}

- (void)initConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}

#pragma mark - <Setters>
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

#pragma mark - Events
- (void)cleanEvent:(UIButton *)sender
{
    if (self.didCleanBlock) {
        self.didCleanBlock();
    }
}


@end
