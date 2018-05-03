//
//  MusicPlaylistMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicPlayingMenu.h"

@interface MusicPlayingMenu()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *screenBackMenu;
@property (nonatomic, strong) UIView *screenDropMenu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *playingGroup;

@end

@implementation MusicPlayingMenu

#pragma mark - Initial

- (instancetype)initPlayingWithDelegate:(id<MusicPlayMenuDelegate>)delegate playingGroup:(NSArray *)playingGroup {
    
    if (self = [super init]) {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        self.backgroundColor = [UIColor clearColor];
        
        self.delegate = delegate;
        if (playingGroup.count) {
            self.playingGroup = playingGroup;
            [self initSubview];
        }
    }
    return self;
}

- (void)initSubview
{
    self.screenBackMenu = [[UIView alloc] initWithFrame:self.frame];
    self.screenBackMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.screenBackMenu.userInteractionEnabled = YES;
    self.screenBackMenu.alpha = 0.0;
    [self addSubview:self.screenBackMenu];
    
    self.screenDropMenu = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.5)];
    self.screenDropMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.screenDropMenu.layer.cornerRadius = 3.0;
    self.screenDropMenu.layer.masksToBounds = YES;
    [self addSubview:self.screenDropMenu];
    
    // 设置毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.screenDropMenu.bounds;
    effectView.alpha = 0.8;
    [self.screenDropMenu addSubview:effectView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.screenDropMenu.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.screenDropMenu addSubview:self.tableView];
    
    // 点按手势
    UITapGestureRecognizer *tapGtr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.screenBackMenu addGestureRecognizer:tapGtr];
}

#pragma mark - Playing action

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect frame = self.screenDropMenu.frame;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat showH = SCREEN_HEIGHT*0.5;
        CGFloat showY = SCREEN_HEIGHT-showH;
        self.screenDropMenu.frame = CGRectMake(frame.origin.x, showY, SCREEN_WIDTH, showH);
    } completion:^(BOOL finished) {
        self.screenBackMenu.alpha = 1.0;
        self.screenDropMenu.alpha = 1.0;
    }];
    
    // 滚动到正在播放的位置
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
}

- (void)dismiss
{
    CGRect frame = self.screenDropMenu.frame;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat hideY = SCREEN_HEIGHT;
        CGFloat hideH = frame.size.height;
        self.screenDropMenu.frame = CGRectMake(frame.origin.x, hideY, SCREEN_WIDTH, hideH);
    } completion:^(BOOL finished) {
        self.screenBackMenu.alpha = 0.0;
        self.screenDropMenu.alpha = 0.0;
        // 移除当前视图
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playingGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *playCellWithIdentifier = @"playCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:playCellWithIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:playCellWithIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.playingGroup.count > indexPath.row) {
        MusicPlayModel *mode = self.playingGroup[indexPath.row];
        cell.textLabel.text = mode.title;
        if (indexPath.row == _playingIndex) { //显示正在播放的歌曲
            cell.textLabel.textColor = [UIColor redColor];
        }else {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.playingGroup.count > indexPath.row) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:DidSelectPlayingAtIndex:)]) {
            
            [self.delegate menu:self DidSelectPlayingAtIndex:indexPath.row];
        }
        _playingIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (decelerate && offsetY < -50.f) {
        
        [self dismiss];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

@end
