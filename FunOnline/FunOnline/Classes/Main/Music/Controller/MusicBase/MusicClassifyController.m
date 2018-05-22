//
//  MusicClassifyController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassifyController.h"
#import "MusicMoreListController.h"
#import "MusicPlayListController.h"
#import "MusicHotViewController.h"
#import "MusicMoreListCell.h"
#import "PagingScrollMenu.h"
#import "MusicClassModel.h"

static NSString *const kMusicMoreCellIdentifier = @"kMusicMoreCellIdentifier";

@interface MusicClassifyController ()<PagingScrollMenuDelegate>
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) NSMutableArray   *titleObjects;
@property (nonatomic, strong) PagingScrollMenu *pageScrollMenu;
@property (nonatomic, assign) NSInteger        scrollIndex;
@property (nonatomic, copy) void(^refreshingBlock)(void);

@end

@implementation MusicClassifyController

#pragma mark - Lazys

- (NSMutableArray *)titleObjects
{
    if (!_titleObjects) {
        
        _titleObjects = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleObjects;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollIndex = 0;
    [self configSubviews];
    [self loadClassTitle];
}

- (void)configSubviews
{
    PagingScrollMenu *pageScrollMenu = [[PagingScrollMenu alloc] initWithOrigin:CGPointMake(0, 0)
                                                                         height:40];
    pageScrollMenu.tintColor = COLORHEX(@"#FF4500");
    pageScrollMenu.hidden = YES;
    pageScrollMenu.delegate = self;
    [self.view addSubview:pageScrollMenu];
    self.pageScrollMenu = pageScrollMenu;
    
    CGFloat maxTop = CGRectGetMaxY(pageScrollMenu.frame);
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT-88-83-maxTop) : (SCREEN_HEIGHT-64-49-maxTop);
    self.tableView.frame = CGRectMake(0, maxTop, SCREEN_WIDTH, height);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kMusicMoreCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [self addRefreshing];
}

- (void)addRefreshing
{
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        if (weakSelf.titleObjects.count <= 0) {
            [weakSelf loadClassTitle];
            weakSelf.refreshingBlock = ^{
                [weakSelf showRefreshing:weakSelf.page];
            };
        }else {
            [weakSelf showRefreshing:weakSelf.page];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf showRefreshing:weakSelf.page];
    }];
}

#pragma mark - PagingScrollMenuDelegate

- (void)scroll:(PagingScrollMenu *)scroll didSelectItemAtIndex:(NSInteger)index {
    _scrollIndex = index;
    // 重刷列表
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - networking

- (void)showRefreshing:(NSInteger)page {
    
    NSDictionary *parameters = @{
                                 @"calcDimension": @"hot",
                                 @"categoryId": @"2",
                                 @"tagName": self.titleObjects[_scrollIndex],
                                 @"device": @"ios",
                                 @"pageSize": @"20",
                                 @"pageId": @(page),
                                 @"status": @"0"
                                 };

    [[RequestManager manager] GET:url_music_list parameters:parameters success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;

        if ([responseObj[@"msg"] isEqualToString:@"成功"]) {
            NSArray *newObjects  = responseObj[@"list"];
            NSInteger totalCount = [responseObj[@"totalCount"] integerValue];

            if (page == 1) {
                [self.dataSource removeAllObjects];
                self.tableView.mj_header.state = MJRefreshStateIdle;
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else if (self.dataSource.count >= totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }

            [self.dataSource addObjectsFromArray:[MusicPlayModel mj_objectArrayWithKeyValuesArray:newObjects]];
            [self.tableView reloadData];
        }

    } failure:^(NSError * _Nonnull error) {

        [self endRefreshing];
    }];
}

- (void)loadClassTitle
{
    NSDictionary *params = @{
                             @"categoryId": @"2",
                             @"contentType": @"album",
                             @"version": @"4.3.26.2",
                             @"device": @"ios",
                             @"scale": @"2"
                             };
    
    WeakSelf;
    [[RequestManager manager] GET:url_music_classify parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"成功"]) {
            NSMutableArray *newTags = [MusicClassModel mj_objectArrayWithKeyValuesArray:responseObj[@"tags"][@"list"]];
            ;
            for (int i = 0; i < newTags.count; i++) {
                MusicClassModel *mode = newTags[i];
                [self.titleObjects addObject:mode.tname];
                if (self.titleObjects.count >= newTags.count) {
                    self.pageScrollMenu.hidden = NO;
                    self.pageScrollMenu.titleStringGroup = self.titleObjects;
                    [self.tableView.mj_header beginRefreshing]; //初次下拉刷新
                    // 网络恢复时重新获取列表数据处理
                    if (weakSelf.refreshingBlock) {
                        weakSelf.refreshingBlock();
                    }
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - TableView For dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicMoreCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - TableView For delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > indexPath.row) {
        MusicPlayModel *model = self.dataSource[indexPath.row];
        MusicPlayListController *detailVC = [[MusicPlayListController alloc] init];
        detailVC.param = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
