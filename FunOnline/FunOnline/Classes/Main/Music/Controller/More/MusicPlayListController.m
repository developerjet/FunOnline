//
//  MusicDetailViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicPlayListController.h"
#import "MusicPlayerViewController.h"
#import "MusicPlayManagerBar.h"
#import "MusicMoreListCell.h"
#import "FLCycleNavMenu.h"
#import "MusciDropMenu.h"

static CGFloat  kPointHeight  = 158.f;
static CGFloat  kHeaderHeight = 240.f;
static NSString *const kPlayListCellIdentifier = @"kPlayListCellIdentifier";

@interface MusicPlayListController ()<MusicPlayerControllerDelegate, MusicPlayBarDelegate>
@property (nonatomic, strong) MusicPlayerViewController *playerVC;
@property (nonatomic, strong) MusicPlayManagerBar       *playBar;
@property (nonatomic, strong) UIVisualEffectView        *effectView;
@property (nonatomic, strong) NSMutableArray            *playItems;
@property (nonatomic, strong) FLCycleNavMenu            *cycleNavMenu;
@property (nonatomic, strong) MusciDropMenu             *dropFlexView;
@property (nonatomic, strong) UIImageView               *backFlexView;
@property (nonatomic, strong) UIButton                  *backButton;
@property (nonatomic, assign) PlayerBackState            playState;
@property (nonatomic, assign) CGRect                     orginalFrame;
@property (nonatomic, assign) BOOL                       isPlaying;

/** 记录当前播放的歌曲位置 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MusicPlayListController

#pragma mark - Lazy

- (NSMutableArray *)playItems
{
    if (!_playItems) {
        _playItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _playItems;
}

- (MusicPlayerViewController *)playerVC
{
    if (!_playerVC) {
        _playerVC = [[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil];
        _playerVC.delegate = self;
    }
    return _playerVC;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.param.title;
    
    [self initSubview];
    [self loadPlayList];
}

- (void)initSubview {
    self.isPlaying    = NO;
    self.currentIndex = 0; //默认值
    self.playState    = PlayerBackStatePause;
    
    self.backFlexView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_drop_image"]];
    self.backFlexView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.8);
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.effectView.frame = self.backFlexView.bounds;
    self.effectView.alpha = 0.4;
    [self.backFlexView addSubview:self.effectView];
    [self.view addSubview:self.backFlexView];
    self.orginalFrame = self.backFlexView.frame;
    
    WeakSelf;
    self.dropFlexView = [[MusciDropMenu alloc] initWithFrame:self.backFlexView.bounds];
    [self.view addSubview:self.dropFlexView];
    [self.view bringSubviewToFront:self.dropFlexView];
    self.dropFlexView.backDidBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kPlayListCellIdentifier];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.cycleNavMenu = [[FLCycleNavMenu alloc] init];
    [self.view addSubview:self.cycleNavMenu];
    self.cycleNavMenu.backDidFinishedBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)configPlayBar {
    if (!self.playItems || self.playItems.count<=0) return;
    
    // 音乐播放管理
    self.playBar = [[MusicPlayManagerBar alloc] initWithOrigin:CGPointMake(0, SCREEN_HEIGHT) plays:self.playItems];
    self.playBar.delegate = self;
    [self.playBar show];
}

- (void)loadPlayList {
    
    NSDictionary *params = @{
                             @"albumId": @(self.param.albumId),
                             @"title": self.param.title,
                             @"device": @"ios",
                             @"position": @"1",
                             @"isAsc": @"1"
                             };
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/1/20?"
                         , self.param.albumId];
    
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] POST:baseUrl parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] integerValue] == 0) {
            NSArray *newObjects = responseObj[@"tracks"][@"list"];
            
            [self reloadMusicAlbum:[AlbumModel mj_objectWithKeyValues:responseObj[@"album"]]];
            [self.playItems addObjectsFromArray:[MusicPlayModel mj_objectArrayWithKeyValuesArray:newObjects]];
            
            [self configPlayBar];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (void)reloadMusicAlbum:(AlbumModel *)album {
    if (!album) return;
    
    self.cycleNavMenu.item  = album;
    self.dropFlexView.album = album;
    [self.backFlexView downloadImage:album.coverMiddle placeholder:@"icon_drop_image"];
}

#pragma mark - <MusicPlayBarDelegate>

- (void)play:(MusicPlayManagerBar *)play DidPlayAtState:(PlayClickEvent)event
{
    if (event == PlayClickEventAlbum) {
        [self.playerVC redisShow];
    }else if (event == PlayClickEventPrev) {
        [self.playerVC prevPlay];
    }else if (event == PlayClickEventNext) {
        [self.playerVC nextPlay];
    }
}

- (void)play:(MusicPlayManagerBar *)play DidPlayOrPause:(PlayerBackState)state
{
    if (state == PlayerBackStatePause) {
        [self.playerVC stopPlay];
    }else {
        if (play.playingIndex == 0) {
            self.playerVC.playingIndex = play.playingIndex;
            [self.playerVC reloadPlayer];
            _isPlaying = YES; //已经开启了播放
        }else {
            [self.playerVC startPlay];
        }
    }
}

#pragma mark - <MusicPlayerControllerDelegate>
- (void)player:(MusicPlayerViewController *)player DidPlaySongAtIndex:(NSInteger)index
{
    self.isPlaying            = YES;
    self.currentIndex         = index;
    self.playBar.playingIndex = index;
}

- (void)player:(MusicPlayerViewController *)player DidPlayerAtState:(PlayerBackState)state
{
    if (state == PlayerBackStatePause) {
        [self.playBar stopRotaAnima];
    }else {
        [self.playBar resumeRotaAnima];
    }
    self.playState = state;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayListCellIdentifier];
    if (self.playItems.count > indexPath.row) {
        cell.model = self.playItems[indexPath.row];
        self.playerVC.playObjects  = self.playItems;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.playItems.count > indexPath.row) {
        self.playBar.playingIndex  = indexPath.row;
        self.playerVC.playObjects  = self.playItems;
        self.playerVC.playingIndex = indexPath.row;
        
        if (_isPlaying) {
            if (_playState == PlayerBackStatePause ||
                _playState == PlayerBackStatePlay) {
                if (_currentIndex == indexPath.row) {
                    [self.playerVC redisShow];
                }else {
                    [self.playerVC show];
                }
            }
        }else {
            _isPlaying = YES;
            [self.playerVC show];
        }
        _currentIndex = indexPath.row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    [self updateFlexScale:offsetY];
}

- (void)updateFlexScale:(CGFloat)offsetY {
    CGFloat alpha = offsetY / kPointHeight;
    
    if (offsetY < kPointHeight) {
        _cycleNavMenu.hideLine = YES;
    }else {
        if (alpha >= 1.f) {
            _cycleNavMenu.hideLine = NO;
        }
    }
    _cycleNavMenu.backgroundColor = [[UIColor colorThemeColor] colorWithAlphaComponent:alpha];
    
    if (offsetY > 0) { //往上拖动
        _backFlexView.frame = ({
            CGRect frame   = _backFlexView.frame;
            frame.origin.y = _orginalFrame.origin.y - offsetY;
            frame;
        });
    }else { //向下拖动(背景图片向宽度改变，高度不变)
        _backFlexView.frame = ({
            CGRect frame      = _backFlexView.frame;
            frame.size.width  = _orginalFrame.size.width-offsetY;
            frame.size.height = _orginalFrame.size.height*frame.size.width/_orginalFrame.size.width;
            frame.origin.x = -(frame.size.width-_orginalFrame.size.width)/2;
            frame;
        });
    }
    // 毛玻璃大小跟着变化
    _effectView.frame = _backFlexView.bounds;
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadPlayList];
    });
}

#pragma mark - dealloc

- (void)dealloc {
    
    if (self.playBar) {
        [self.playBar remover];
        self.playBar = nil;
        [self.playerVC removeFromParentViewController];
    }
}

@end

