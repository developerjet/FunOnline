//
//  MusicClassHeaderView.m
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassHeaderView.h"

@implementation MusicClassHeaderView

#pragma mark - Initialization

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        backgroundView.backgroundColor = [UIColor colorWhiteColor];
        self.backgroundView = backgroundView;
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play_arrow"]];
        [self.contentView addSubview:_arrowView];
        
        _classLabel = [[UILabel alloc] init];
        _classLabel.font = [UIFont systemFontOfSize:16];
        _classLabel.textColor = [UIColor colorDarkTextColor];
        [self.contentView addSubview:_classLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat s_w = self.contentView.frame.size.width;
    CGFloat s_h = self.contentView.frame.size.height;
    
    CGFloat space   = 10;
    CGFloat imageWH = 30;
    CGFloat originY = (s_h - imageWH) * 0.5;
    _arrowView.frame = CGRectMake(space, originY, imageWH, imageWH);
    
    CGFloat labelX = CGRectGetMaxX(_arrowView.frame) + 5;
    CGFloat labelY = (s_h - 20) * 0.5;
    CGFloat labelW = s_w - labelX - space;
    _classLabel.frame = CGRectMake(labelX, labelY, labelW, 20);
    
    CGFloat lineH = 0.25;
    _lineView.frame = CGRectMake(0, s_h-lineH, SCREEN_WIDTH, lineH);
}

@end
