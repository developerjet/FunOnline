//
//  MusciDropMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusciDropMenu.h"

@interface MusciDropMenu()

@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLable;
@property (nonatomic, strong) UIButton *countButton;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation MusciDropMenu

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configSubviews];
        [self initConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configSubviews];
        [self initConstraints];
    }
    return self;
}

- (void)configSubviews
{
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.layer.borderWidth = 4.f;
    _coverImageView.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    _coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _coverImageView.layer.shadowOffset = CGSizeMake(4,4);
    _coverImageView.layer.shadowOpacity = 0.8f;
    _coverImageView.layer.shadowRadius = 4.f;
    [self addSubview:_coverImageView];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.cornerRadius = 15.f;
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = [UIColor colorWhiteColor];
    [self addSubview:_nameLabel];
    
    _introLable = [[UILabel alloc] init];
    _introLable.numberOfLines = 2;
    _introLable.font = [UIFont systemFontOfSize:17];
    _introLable.textColor = [UIColor colorWhiteColor];
    [self addSubview:_introLable];
    
    _tagsLabel = [[UILabel alloc] init];
    _tagsLabel.font = [UIFont systemFontOfSize:17];
    _tagsLabel.textColor = [UIColor colorWhiteColor];
    [self addSubview:_tagsLabel];
    
    _countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _countButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _countButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_countButton setImage:[UIImage imageNamed:@"icon_music_star"] forState:UIControlStateNormal];
    [self.coverImageView addSubview:_countButton];
}

- (void)initConstraints
{
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(80);
        make.left.equalTo(self).offset(15);
        make.width.height.equalTo(@120);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(20);
        make.width.height.equalTo(@30);
        make.top.equalTo(self.coverImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.centerY.equalTo(self.avatarImageView);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.introLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverImageView);
        make.left.equalTo(self.avatarImageView);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel);
        make.left.equalTo(self.introLable);
        make.bottom.equalTo(self.coverImageView);
    }];
    
    [self.countButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverImageView);
        make.left.equalTo(self.coverImageView).offset(2);
        make.right.equalTo(self.coverImageView).offset(-2);
    }];
}

#pragma mark - Private Setter

- (void)setAlbum:(AlbumModel *)album {
    _album = album;
    
    self.titleLabel.text = album.title;
    self.nameLabel.text  = album.nickname;
    self.tagsLabel.text  = album.tags.length ? album.tags : @"暂无分类";
    self.introLable.text = album.intro.length ? album.intro : @"暂无简介";
    [self.coverImageView downloadImage:album.coverMiddle placeholder:@"icon_default_image"];
    [self.avatarImageView downloadImage:album.avatarPath placeholder:@"icon_default_avatar"];
    [self.countButton setTitle:[NSString stringWithFormat:@"%.f万", album.playTimes / 10000.0] forState:UIControlStateNormal];
}

@end
