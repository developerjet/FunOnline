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

static CGFloat  kPointHeight = 158.f;
static NSString *const kPlayListCellIdentifier = @"kPlayListCellIdentifier";

@interface MusicPlayListController ()<MusicPlayerControllerDelegate, MusicPlayBarDelegate>
@property (nonatomic, strong) MusicPlayerViewController *playerVC;
@property (nonatomic, strong) MusicPlayManagerBar       *playBar;
@property (nonatomic, strong) NSMutableArray            *playItems;
@property (nonatomic, strong) FLCycleNavMenu            *cycleNavMenu;
@property (nonatomic, strong) MusciDropMenu             *dropMenu;
@property (nonatomic, assign) PlayerBackState            playState;
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
    
    self.dropMenu = [MusciDropMenu loadNibDrop];
    self.dropMenu.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    [self.view addSubview:self.dropMenu];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kPlayListCellIdentifier];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    self.tableView.tableHeaderView = self.dropMenu;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    self.cycleNavMenu = [[FLCycleNavMenu alloc] init];
    [self.view addSubview:self.cycleNavMenu];
    self.cycleNavMenu.backDidFinishedBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.dropMenu.backDidBlock = ^{
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
            AlbumModel *album = [AlbumModel mj_objectWithKeyValues:responseObj[@"album"]];
            self.dropMenu.album = album;
            self.cycleNavMenu.item = album;
            
            NSArray *newObjects = responseObj[@"tracks"][@"list"];
            [self.playItems addObjectsFromArray:[MusicPlayModel mj_objectArrayWithKeyValuesArray:newObjects]];
            
            [self configPlayBar];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
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
        }else {
            [self.playerVC startPlay];
        }
    }
}

#pragma mark - <MusicPlayerControllerDelegate>
- (void)player:(MusicPlayerViewController *)player DidPlaySongAtIndex:(NSInteger)index
{
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
    
    if (self.playItems.count > indexPath.row) {
        self.playBar.playingIndex  = indexPath.row;
        self.playerVC.playObjects  = self.playItems;
        self.playerVC.playingIndex = indexPath.row;
        if (indexPath.row == _currentIndex) {
            if (self.isPlaying) {
                if (_playState == PlayerBackStatePause ||
                    _playState == PlayerBackStatePlay) {
                    [self.playerVC redisShow];
                }
            }else {
                [self.playerVC show];
            }
        }else {
            [self.playerVC show];
            self.isPlaying = YES;
        }
        
        _currentIndex = indexPath.row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < kPointHeight) { // 0~1 => 0/headHeight ~ headHeight/headHeight
        _cycleNavMenu.showTools = NO;
        _cycleNavMenu.titleColor = [UIColor colorWhiteColor];
        _cycleNavMenu.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:offsetY/kPointHeight];
    }else {
        _cycleNavMenu.showTools = YES;
        _cycleNavMenu.titleColor = [UIColor colorWhiteColor];
        _cycleNavMenu.backgroundColor = [[UIColor colorThemeColor] colorWithAlphaComponent:offsetY/kPointHeight];
    }
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
