//
//  MusicPlayBar.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicPlayManagerBar.h"
#import "RotateImageView.h"
#import <UIButton+WebCache.h>

@interface MusicPlayManagerBar()

@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *albumButton;
@property (nonatomic, assign) CGFloat  customHeight;
@property (nonatomic, strong) UIVisualEffectView *effectView; //毛玻璃
@property (nonatomic, strong) NSArray *currentPlays; //当前歌单播放信息
@property (nonatomic, assign) BOOL isRotaing; //是否开启了旋转

@end


@implementation MusicPlayManagerBar

#pragma mark - Life Cycle

- (instancetype)initWithOrigin:(CGPoint)origin plays:(NSArray *)plays
{
    self.customHeight = iPhoneX ? 83 : 60;
    return [self initWithOrigin:origin width:[UIScreen mainScreen].bounds.size.width height:self.customHeight plays:plays];
}

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width height:(CGFloat)height plays:(NSArray *)plays {
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, height)]) {
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        if (plays) {
            self.isRotaing    = NO;
            self.playingIndex = 0; //默认值
            self.currentPlays = plays;
        }
        [self initPlaySubview];
        [self initConstraints];
    }
    return self;
}

- (void)initPlaySubview
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.effectView.alpha = 0.7;
    [self addSubview:self.effectView];
    
    // 点击歌曲详情
    UIImage *placeholderImage = [UIImage imageNamed:@"music_lock_screen_placeholder"];
    self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.albumButton setImage:placeholderImage forState:UIControlStateNormal];
    self.albumButton.layer.cornerRadius = 27;
    self.albumButton.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    self.albumButton.layer.borderWidth = 2.5;
    self.albumButton.layer.masksToBounds = YES;
    [self addSubview:self.albumButton];
    
    // 上一曲
    self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prevButton setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    [self addSubview:self.prevButton];
    
    // 下一曲
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setImage:[UIImage imageNamed:@"next_song"] forState:UIControlStateNormal];
    [self addSubview:self.nextButton];
    
    // 播放控制
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateSelected];
    [self addSubview:self.playButton];
    
    self.prevButton.tag  = 1001;
    self.nextButton.tag  = 1002;
    self.albumButton.tag = 1000;
    
    [self.prevButton addTarget:self action:@selector(playDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(playDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.albumButton addTarget:self action:@selector(playDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playBackControl:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstraints {
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(@54);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@50);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playButton);
        make.width.height.equalTo(self.playButton);
        make.left.equalTo(self.playButton.mas_right).offset(15);
    }];
    
    [self.prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playButton);
        make.width.height.equalTo(self.playButton);
        make.right.equalTo(self.playButton.mas_left).offset(-15);
    }];
}

- (void)startRotaAnima {
    self.playButton.selected = YES;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 20.0;  // 旋转时间20秒
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.albumButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotaAnima {
    self.playButton.selected = NO;
    
    CFTimeInterval pausedTime = [self.albumButton.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.albumButton.layer.speed = 0.0; // 停止旋转
    self.albumButton.layer.timeOffset = pausedTime;
}

- (void)resumeRotaAnima {
    self.playButton.selected = YES;
    
    if (self.albumButton.layer.timeOffset == 0) {
        [self startRotaAnima];
        return;
    }
    
    CFTimeInterval pausedTime = self.albumButton.layer.timeOffset;
    self.albumButton.layer.speed = 1.0; // 开始旋转
    self.albumButton.layer.timeOffset = 0.0;
    self.albumButton.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.albumButton.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime; // 恢复时间
    self.albumButton.layer.beginTime = timeSincePause; // 从暂停的时间点开始旋转
}

#pragma mark - Player event

- (void)playDidEvent:(UIButton *)button {
    PlayClickEvent event = button.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:DidPlayAtState:)]) {
        
        [self.delegate play:self DidPlayAtState:event];
    }
}

- (void)playBackControl:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        if (_playingIndex == 0) {
            [self reloadPlayer:self.currentPlays[_playingIndex]];
        }
        if (_isRotaing) {
            [self resumeRotaAnima];
        }else {
            [self startRotaAnima];
        }
        _state = PlayerBackStatePlay;
    }else {
        _isRotaing = YES; //已经开启旋转
        [self stopRotaAnima];
        _state = PlayerBackStatePause;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:DidPlayOrPause:)]) {
        
        [self.delegate play:self DidPlayOrPause:_state];
    }
}

#pragma mark - Reload player

- (void)reloadPlayer:(MusicPlayModel *)mode {
    if (!mode) return;
    
    [self startRotaAnima];
    self.playButton.selected = YES; //显示为播放
    [self.albumButton sd_setImageWithURL:[NSURL URLWithString:mode.coverLarge]
                                forState:UIControlStateNormal
                        placeholderImage:[UIImage imageNamed:@"music_lock_screen_placeholder"]];
}

- (void)setPlayingIndex:(NSInteger)playingIndex {
    _playingIndex = playingIndex;
    
    MusicPlayModel *model = self.currentPlays[playingIndex];
    [self reloadPlayer:model];
}

#pragma mark - Display manager

- (void)show
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.mj_y = windows.mj_h - self.customHeight;
    }];
}

- (void)dismiss
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mj_y = windows.tj_height;
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
    }];
}

- (void)remover
{
    [self dismiss];
    [self removeFromSuperview]; //移除当前
}

@end
