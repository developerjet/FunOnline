//
//  MusicDetailViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicMoreListController.h"
#import "MusicPlayListController.h"
#import <AdSupport/AdSupport.h>
#import "MusicMoreListCell.h"

static NSString *const kMoreListCellIdentifier = @"kMoreListCellIdentifier";

@interface MusicMoreListController ()

@property (nonatomic, strong) NSMutableArray *dataObjects;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString  *urlString;

@end

@implementation MusicMoreListController

- (NSMutableArray *)dataObjects
{
    if (!_dataObjects) {
        
        _dataObjects = [NSMutableArray array];
    }
    return _dataObjects;
}

- (NSDictionary *)parameters
{
    if (!_parameters) {
        
        _parameters = [[NSDictionary alloc] init];
    }
    return _parameters;
}

- (NSString *)urlString {
    
    if (!_urlString) {
    
        _urlString = [[NSString alloc] init];
    }
    return _urlString;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.param.tname ? self.param.tname : self.param.title;
    
    [self initTableView];
}

- (void)initTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kMoreListCellIdentifier];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf showRefreshing:weakSelf.page];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf showRefreshing:weakSelf.page];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)showRefreshing:(NSInteger)page {
    if (!_isMore) {
        _urlString = url_music_list;
        _parameters = @{
                        @"calcDimension": @"hot",
                        @"categoryId": @"2",
                        @"tagName": self.param.tname,
                        @"device": @"ios",
                        @"pageSize": @"20",
                        @"pageId": @(page),
                        @"status": @"0"
                        };
    }else {
        _urlString = url_more_music;
        _parameters = @{
                        @"appid": @"0",
                        @"calcDimension": self.param.calcDimension,
                        @"categoryId": @"2",
                        @"device": @"iPhone",
                        @"deviceId": [self getDeviceID],
                        @"keywordId": @(self.param.keywordId),
                        @"network": @"WIFI",
                        @"operator": @"3",
                        @"pageId": @(page),
                        @"pageSize": @"20",
                        @"scale": @"3",
                        @"uid": @"0",
                        @"version": @"6.3.90",
                        @"xt": @"1526871454723"
                        };
    }
    
    [[RequestManager manager] GET:self.urlString parameters:self.parameters success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"成功"]) {
            NSArray *newObjects  = responseObj[@"list"];
            NSInteger totalCount = [responseObj[@"totalCount"] integerValue];
            
            if (page == 1) {
                [self.dataObjects removeAllObjects];
                self.tableView.mj_header.state = MJRefreshStateIdle;
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else if (self.dataObjects.count >= totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [self.dataObjects addObjectsFromArray:[MusicPlayModel mj_objectArrayWithKeyValuesArray:newObjects]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

- (NSString *)getDeviceID
{
    NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return IDFA;
}

#pragma mark - TableView For dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreListCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.dataObjects.count > indexPath.row) {
        cell.model = self.dataObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - TableView For delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataObjects.count > indexPath.row) {
        MusicPlayModel *model = self.dataObjects[indexPath.row];
        MusicPlayListController *detailVC = [[MusicPlayListController alloc] init];
        detailVC.param = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
