//
//  WallpaperCollectionCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WallPaperCollectionCell.h"
#import "UIImageView+SDWebImage.h"
#import "UIColor+Extension.h"

@interface WallPaperCollectionCell()
@property (nonatomic, strong) UIImageView *elevationImgView;
@property (nonatomic, strong) UIButton    *checkButton;
@property (nonatomic, strong) UILabel     *titleLabel;

@end

@implementation WallPaperCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        [self configSubview];
    }
    return self;
}

- (void)configSubview
{
    self.elevationImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.elevationImgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.contentView addSubview:self.titleLabel];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.hidden = YES; //默认隐藏
    [self.checkButton setImage:[UIImage imageNamed:@"iocn_lookup"] forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(lookupEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkButton];
}

#pragma mark - setter

- (void)setModel:(WallPaperModel *)model {
    _model = model;
    
    self.titleLabel.text = model.name ? model.name : @"";
    [self.elevationImgView downloadImage:model.img ? model.img : model.cover placeholder:@"icon_loading_image"];
}

- (void)setIsCheck:(BOOL)isCheck {
    
    _isCheck = isCheck;
    
    self.checkButton.hidden = !isCheck;
}

#pragma mark - action

- (void)lookupEvent:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:DidSelectIndexAtItem:)]) {
        
        [self.delegate cell:self DidSelectIndexAtItem:self.model];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 5;
    CGFloat superW = self.contentView.frame.size.width;
    CGFloat superH = self.contentView.frame.size.height;
    
    CGFloat labelH = 21;
    CGFloat labelW = superW - margin * 2;
    self.elevationImgView.frame = self.contentView.bounds;
    self.titleLabel.frame = CGRectMake(margin, superH -  margin - labelH, labelW, labelH);
    
    CGFloat btnW = 50;
    CGFloat btnH = 30;
    CGFloat btnX = superW - btnW;
    CGFloat btnY = superH - btnH;
    self.checkButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

@end
