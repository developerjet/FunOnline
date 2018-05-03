//
//  MusicDetailViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicMoreListController.h"
#import "MusicPlayListController.h"
#import "MusicMoreListCell.h"

static NSString *const kMoreListCellIdentifier = @"kMoreListCellIdentifier";

@interface MusicMoreListController ()

@property (nonatomic, strong) NSMutableArray *dataObjects;

@end

@implementation MusicMoreListController

- (NSMutableArray *)dataObjects
{
    if (!_dataObjects) {
        
        _dataObjects = [NSMutableArray array];
    }
    return _dataObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.param.tname;
    
    [self configTableView];
}

- (void)configTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kMoreListCellIdentifier];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    
    NSDictionary *params  = @{
                              @"calcDimension": @"hot",
                              @"categoryId": self.param.categoryId,
                              @"tagName": self.param.tname,
                              @"device": @"ios",
                              @"pageSize": @"20",
                              @"pageId": @(page),
                              @"status": @"0"
                              };

    
    [[RequestManager manager] GET:url_music_list parameters:params success:^(id  _Nullable responseObj) {
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
