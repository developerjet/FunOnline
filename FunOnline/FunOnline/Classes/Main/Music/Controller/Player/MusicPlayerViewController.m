//
//  MusicPlayerViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicPlayingMenu.h"
#import "RotateImageView.h"

@interface MusicPlayerViewController ()<UIGestureRecognizerDelegate, MusicPlayMenuDelegate>

@property (weak, nonatomic) IBOutlet UIVisualEffectView *screenEffectView;
@property (weak, nonatomic) IBOutlet RotateImageView    *albumImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *screenImageView;
@property (weak, nonatomic) IBOutlet UILabel            *playDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel            *playCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel            *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton           *playModeButton;
@property (weak, nonatomic) IBOutlet UIButton           *playingButton;
@property (weak, nonatomic) IBOutlet UISlider           *playingSlider;
@property (weak, nonatomic) IBOutlet UIButton           *prevPlayButton;
@property (weak, nonatomic) IBOutlet UIButton           *nextPlayButton;
@property (weak, nonatomic) IBOutlet UIButton           *hidePlayButton;
@property (weak, nonatomic) IBOutlet UIView             *screenMainView;

/** 当前后台播放图片保存设置 */
@property (nonatomic, strong) NSMutableDictionary *musicImageDic;
/** 记录当前播放模型数据 */
@property (nonatomic, strong) MusicPlayModel *currentModel;
/** 播放音频源 */
@property (nonatomic, strong) AVPlayerItem *playItem;
/** 远程音乐播放 */
@property (nonatomic, strong) AVPlayer *player;
/** 播放监听观察 */
@property (nonatomic, assign) id timeObserve;

@end

@implementation MusicPlayerViewController


#pragma mark - Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    // 接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    // 取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialization];
}

- (void)initialization
{
    self.playMode = PlayingModeAllLoopPlay; //默认循环播放
    
    self.screenMainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    self.albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumImageView.layer.cornerRadius = (SCREEN_WIDTH - 70) * 0.5;
    self.albumImageView.layer.borderColor = [UIColor colorLightTextColor].CGColor;
    self.albumImageView.layer.borderWidth = 6.0;
    self.albumImageView.layer.masksToBounds = YES;
    
    self.playingSlider.minimumValue = 0.0;
    self.playingSlider.userInteractionEnabled = YES;
    self.playingSlider.minimumTrackTintColor = [UIColor colorWhiteColor];
    self.playingSlider.maximumTrackTintColor = [UIColor colorThemeColor];
    [self.playingSlider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateNormal];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [self.screenEffectView setEffect:blurEffect];
    
    [self.nextPlayButton addTarget:self action:@selector(nextPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.prevPlayButton addTarget:self action:@selector(prevPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.hidePlayButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加向下轻扫手势
    [self addBottomSwipGesture:self.view];
}


#pragma mark - UISwipeGestureRecognizer

- (void)addBottomSwipGesture:(UIView *)view
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipBottomEvent:)];
    swip.direction = UISwipeGestureRecognizerDirectionDown;
    swip.delegate = self;
    [view addGestureRecognizer:swip];
}

- (void)swipBottomEvent:(UISwipeGestureRecognizer *)swip {
    
    switch (swip.direction) { //判断方向
        case UISwipeGestureRecognizerDirectionDown:
            [self dismiss];
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - Add Player Observe

- (void)initPlayObserve {
    
    WeakSelf;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.playItem.duration);
        if (current) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.playingSlider.value    = current / total;
                weakSelf.playCurrentLabel.text  = [weakSelf timeFormatted:current];
                weakSelf.playDurationLabel.text = [weakSelf timeFormatted:total];
            });
        }
    }];
    
    // 播放完成监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

// 当前音乐播放完成
- (void)playFinished:(NSNotification *)noti {
    [self stopPlay]; //停止播放
    
    if (self.playMode == PlayingModeAllLoopPlay) {
        if (self.playingIndex >= self.playObjects.count-1) {
            self.playingIndex = 0; //从第一首开始播放
        }else {
            self.playingIndex++;
        }
    }else if(self.playMode == PlayingModeSingleLoop) {
        self.playingIndex = self.playingIndex;
    }else {
        self.playingIndex = [self getRandomNumber];
    }
    
    [self reloadPlayer];
}

// 更新播放信息
- (void)reloadPlayer
{
    self.playingSlider.value = 0.0;
    
    // 更新界面显示
    MusicPlayModel *playerModel = self.playObjects[_playingIndex];
    self.musicTitleLabel.text = playerModel.title;
    self.artistNameLabel.text = playerModel.nickname;
    [self.albumImageView downloadImage:playerModel.coverLarge placeholder:@"music_lock_screen_placeholder"];
    [self.screenImageView downloadImage:playerModel.coverLarge placeholder:@"icon_logon_screen"];
    self.currentModel = playerModel;
    
    // 更新播放音源文件&管理信息
    [self play:playerModel.playUrl64];
    [self updetaPlayingIndexDelegate];
    [self updateLockedScreenMusic];
}

- (void)refreshPlayUI {
    // 仅更新界面显示
    MusicPlayModel *playerModel = self.playObjects[_playingIndex];
    self.musicTitleLabel.text = playerModel.title;
    self.artistNameLabel.text = playerModel.nickname;
    [self.albumImageView downloadImage:playerModel.coverLarge placeholder:@"music_lock_screen_placeholder"];
    [self.screenImageView downloadImage:playerModel.coverLarge placeholder:@"icon_logon_screen"];
    self.currentModel = playerModel;
}

#pragma mark - ***************************** KVO *****************************
// 在KVO方法中获取其(status&loadedTimeRanges)的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                [XDProgressHUD showHUDWithText:@"暂时不能播放，请重试" hideDelay:1.0];
                [self.albumImageView stopRotating];
                break;
            case AVPlayerStatusReadyToPlay:
                [XDProgressHUD showHUDWithText:@"马上为您播放" hideDelay:1.0];
                [self initPlayObserve];
                break;
            case AVPlayerStatusFailed:
                [XDProgressHUD showHUDWithText:@"加载失败，请检查网络设置" hideDelay:1.0];
                [self.albumImageView stopRotating];
                break;
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        NSString *currentProgress = [NSString stringWithFormat:@"%.2f/100.00", 100.f * scale];
        [XDProgressHUD showHUDWithIndeterminate:currentProgress];
        if (totalLoadTime >= duration) {
            [self.albumImageView startRotating];
            self.playingButton.selected = YES; //播放状态
            [XDProgressHUD hideHUD];
        }
    }
}

#pragma mark - Playing Control

- (void)setPlayerItem:(NSString *)songURL {
    NSURL * url = [NSURL URLWithString:songURL];
    _playItem = [[AVPlayerItem alloc] initWithURL:url];
    
    [self removeObserve];
}

- (void)setPlay {
    _player = [[AVPlayer alloc] initWithPlayerItem:_playItem];
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil]; //监听媒体加载状态
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; //监听播放资源缓冲
}

- (void)startPlay {
    [_player play];
    [self updateLockedScreenMusic]; //更新锁屏歌曲播放信息
    self.playingButton.selected = YES;
    self.playState = PlayerBackStatePlay;
    [self.albumImageView resumeRotate];
    [self updatePlayingStateDelegate];
}

- (void)stopPlay {
    [_player pause];
    self.playingButton.selected = NO;
    self.playState = PlayerBackStatePause;
    [self.albumImageView stopRotating];
    [self updatePlayingStateDelegate];
}

- (void)play:(NSString *)songURL {
    [self setPlayerItem:songURL];
    [self setPlay];
    [self startPlay];
}

- (IBAction)playingEvent:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        if (!self.player && _playingIndex == 0) { //初始化播放实例
            [self restPlayerItem];
        }else {
            [self startPlay]; //开始&继续播放
        }
    }else {
        [self stopPlay]; //暂停播放
    }
}

- (void)restPlayerItem
{
    self.playState = PlayerBackStatePlay; //播放状态
    MusicPlayModel *playerModel = self.playObjects[_playingIndex];
    [self play:playerModel.playUrl64];
    [self updatePlayingStateDelegate];
    [self updetaPlayingIndexDelegate];
}

#pragma mark - Public Play Controll

- (void)nextPlay {
    if (self.playingIndex >= self.playObjects.count-1) {
        self.playingIndex = 0;
        return;
    }
    
    if (self.playMode == PlayingModeAllLoopPlay) { //循环播放
        self.playingIndex++;
    }else if (self.playMode == PlayingModeSingleLoop) { //单曲循环
        self.playingIndex = self.playingIndex;
    }else { //随机播放
        self.playingIndex = [self getRandomNumber];
    }
    
    [self reloadPlayer];
}

- (void)prevPlay {
    if (self.playingIndex <= 0) {
        [XDProgressHUD showHUDWithText:@"亲，已经是第一首了" hideDelay:1.0];
        return;
    }
    
    if (self.playMode == PlayingModeAllLoopPlay) { //循环播放
        self.playingIndex--;
    }else if (self.playMode == PlayingModeSingleLoop) { //单曲循环
        self.playingIndex = self.playingIndex;
    }else { //随机播放
        self.playingIndex = [self getRandomNumber];
    }
    
    [self reloadPlayer];
}

- (IBAction)showPlayingMenuEvent:(id)sender {
    
    MusicPlayingMenu *playingMenu = [[MusicPlayingMenu alloc] initPlayingWithDelegate:self
                                                                         playingGroup:self.playObjects];
    playingMenu.playingIndex = self.playingIndex;
    [playingMenu show];
}


#pragma mark - MusicPlayMenuDelegate

- (void)menu:(MusicPlayingMenu *)menu DidSelectPlayingAtIndex:(NSInteger)index {
    
    self.playingIndex = index;
    [self reloadPlayer];
}

#pragma mark - 进度条改变值时触发
//拖动进度条改变值时触发
- (IBAction)sliderValueChange:(UISlider *)sender {
    
    // 更新播放时间
    [self updateTime];
}

//点按进度条时触发
- (IBAction)sliderTapValueChange:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // 获取点的x的位置
        CGFloat offsetX = [sender locationInView:self.playingSlider].x;
        // 获取滑块的比例值
        float ratio = offsetX / self.playingSlider.bounds.size.width;
        self.playingSlider.value = 1 * ratio;
        // 更新播放时间
        [self updateTime];
    }
}

// 播放模式的
- (IBAction)playingModeChange:(UIButton *)button
{
    if (self.playMode == PlayingModeAllLoopPlay) {
        self.playMode = PlayingModeSingleLoop;
        [self updatePlayMode:self.playMode];
        return;
    }
    if (self.playMode == PlayingModeSingleLoop) {
        self.playMode = PlayingModeRandomPlay;
        [self updatePlayMode:self.playMode];
        return;
    }
    if (self.playMode == PlayingModeRandomPlay) {
        self.playMode = PlayingModeAllLoopPlay;
        [self updatePlayMode:self.playMode];
        return;
    }
}

- (void)updatePlayMode:(PlayingMode)mode
{
    switch (mode) {
        case PlayingModeAllLoopPlay:
            [XDProgressHUD showHUDWithText:@"循环播放" hideDelay:1.0];
            [self.playModeButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case PlayingModeSingleLoop:
            [XDProgressHUD showHUDWithText:@"单曲循环" hideDelay:1.0];
            [self.playModeButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case PlayingModeRandomPlay:
            [XDProgressHUD showHUDWithText:@"随机播放" hideDelay:1.0];
            [self.playModeButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

// 更新代理设置信息
- (void)updetaPlayingIndexDelegate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:DidPlaySongAtIndex:)]) {
        
        [self.delegate player:self DidPlaySongAtIndex:self.playingIndex];
    }
}

- (void)updatePlayingStateDelegate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:DidPlayerAtState:)]) {
        
        [self.delegate player:self DidPlayerAtState:self.playState];
    }
}

- (int)getRandomNumber
{
    return (int)(arc4random() % (self.playObjects.count));
}

#pragma mark - 更新播放时间
- (void)updateTime {
    CMTime duration = self.player.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(_playingSlider.value) * completeTime;
    
    // 播放器定位到对应的位置
    CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    [self.player seekToTime:targetTime];
    
    // 如果当前时暂停状态，则自动播放
    if (self.player.rate == 0) {
        
        [self startPlay];
    }
}

#pragma mark - Display processing

- (void)show {
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    self.view.frame = windows.frame;
    [windows addSubview:self.view];
    self.view.mj_y = self.view.mj_h;
    self.view.hidden = NO;
    
    windows.userInteractionEnabled = NO;  //以免在动画过程中用户多次点击，或者造成其他事件的发生
    [UIView animateWithDuration:0.25 animations:^{
        self.view.mj_y = 0;
    }completion:^(BOOL finished) {
        windows.userInteractionEnabled = YES;
        [self reloadPlayer];
    }];
}

- (void)redisShow {
    if (self.player.rate == 0 && self.playingIndex <= 0) {
        [self.albumImageView stopRotating];
    }else {
        if (_playState == PlayerBackStatePlay) {
            [self.albumImageView resumeRotate];
        }
    }
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    self.view.frame = windows.frame;
    [windows addSubview:self.view];
    self.view.mj_y = self.view.mj_h;
    self.view.hidden = NO;
    
    windows.userInteractionEnabled = NO;  //以免在动画过程中用户多次点击，或者造成其他事件的发生
    [UIView animateWithDuration:0.25 animations:^{
        self.view.mj_y = 0;
    }completion:^(BOOL finished) {
        windows.userInteractionEnabled = YES;
        [self refreshPlayUI];
    }];
}

- (void)dismiss {
    [self.albumImageView stopRotating]; // 停止旋转
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    windows.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.mj_y = self.view.mj_h;
    }completion:^(BOOL finished) {
        self.view.hidden = YES; //view看不到了，将之隐藏掉，可以减少性能的消耗
        windows.userInteractionEnabled = YES;
    }];
}


#pragma mark - ***************** 音乐锁屏信息展示 *****************
// 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        // 获取当前歌舞播放时间及时间设置
        Float64 completeTime = CMTimeGetSeconds(self.player.currentItem.asset.duration);
        Float64 currentTime  = CMTimeGetSeconds(self.player.currentItem.currentTime);
        
        // 播放器定位到对应的位置
        CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
        [self.player seekToTime:targetTime];
        
        // 初始化播放中心&信息
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        
        // 专辑名称
        info[MPMediaItemPropertyAlbumTitle] = self.currentModel.title;
        // 歌手
        info[MPMediaItemPropertyArtist] = self.currentModel.nickname;
        // 歌曲名称
        info[MPMediaItemPropertyTitle] = self.currentModel.title;;
        // 设置图片
        info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self getMusicImageWithMusicId:self.currentModel]];
        // 设置显示播放速率
        info[MPNowPlayingInfoPropertyPlaybackRate] = @(1.0);
        // 设置持续时间（歌曲的总时间）
        info[MPMediaItemPropertyPlaybackDuration] = @(completeTime);
        // 设置当前播放进度
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(currentTime);
        // 切换,设置播放信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
        
        // 开始监听远程控制事件
        // 成为第一响应者（必备条件）
        [self becomeFirstResponder];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
}

//监听远程交互方法
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlPlay: //播放
            [self.player play];
            break;
        case UIEventSubtypeRemoteControlPause:  //停止
            [self.player pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack: //下一首
            [self nextPlay];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack: //上一首
            [self prevPlay];
            break;
            
        default:
            break;
    }
}

#pragma mark - Loading MPMediaItemPropertyArtwork
//获取远程网络图片，如有缓存取缓存，没有缓存，远程加载并缓存
- (UIImage*)getMusicImageWithMusicId:(MusicPlayModel *)model
{
    UIImage *image = nil;
    NSString *key = [NSString stringWithFormat:@"%ld", model.trackId];
    UIImage *cacheImage = self.musicImageDic[key];
    if (cacheImage) {
        image = cacheImage;
    }else{
        if (model.coverLarge.length) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverLarge]];
            image = [UIImage imageWithData:data];
        }else {
            image = [UIImage imageNamed:@"music_placeholder"];
        }
        if (image) {
            [self.musicImageDic setObject:image forKey:key];
        }
    }
    return image;
}

-(NSMutableDictionary *)musicImageDic
{
    if (_musicImageDic == nil) {
        _musicImageDic = [NSMutableDictionary dictionary];
    }
    return _musicImageDic;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [self removeObserve];
}

- (void)removeObserve {

    if (_timeObserve) {
        [self stopPlay];
        [self.player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    if (_player.currentItem) {
        [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    }
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

@end
