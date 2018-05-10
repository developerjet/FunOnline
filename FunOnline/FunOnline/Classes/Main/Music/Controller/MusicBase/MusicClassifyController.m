//
//  MusicClassifyController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassifyController.h"
#import "MusicMoreListController.h"
#import "MusicHotViewController.h"
#import "MusicClassifyCell.h"
#import "MusicClassModel.h"

static NSString *const kMusicClassifyCellIdentifier = @"kMusicClassifyCellIdentifier";

@interface MusicClassifyController ()
@property (nonatomic, strong) NSMutableArray *imageObjects;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MusicClassifyController

#pragma mark - Lazys

- (NSMutableArray *)imageObjects
{
    if (!_imageObjects) {
        
        _imageObjects = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageObjects;
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
    
    self.title = @"乐库";
    self.view.backgroundColor = COLORHEX(@"F8F8F8");
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"more_icon"
                                                               highlightImg:@"more_icon"
                                                                     target:self
                                                                     action:@selector(jumpToMore)];
    
    [self configuraTable];
}

- (void)configuraTable
{
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT-88-83) : (SCREEN_HEIGHT-64-49);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicClassifyCell" bundle:nil] forCellReuseIdentifier:kMusicClassifyCellIdentifier];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadClassifys];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)jumpToMore
{
    MusicHotViewController *recommendVC = [[MusicHotViewController alloc] init];
    [self.navigationController pushViewController:recommendVC animated:YES];
}


#pragma mark - Request

- (void)loadClassifys
{
    NSDictionary *params = @{
                             @"categoryId": @"2",
                             @"contentType": @"album",
                             @"version": @"4.3.26.2",
                             @"device": @"ios",
                             @"scale": @"2"
                             };
    
    [[RequestManager manager] GET:url_music_classify parameters:params success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        [self endRefreshing];
        
        if ([responseObj[@"msg"] isEqualToString:@"成功"]) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            
            NSArray *newObjects = responseObj[@"tags"][@"list"];
            [self.dataSource addObjectsFromArray:[MusicClassModel mj_objectArrayWithKeyValuesArray:newObjects]];
            
            NSString *prefix = @"timg";
            for (int idx = 0; idx < self.dataSource.count; idx++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%d", prefix, idx];
                [self.imageObjects addObject:imageName];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - table for data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicClassifyCellIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.imageName = self.imageObjects[indexPath.row];
    }
    
    return cell;
}

#pragma mark - table for delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        MusicClassModel *model = self.dataSource[indexPath.row];
        MusicMoreListController *listVC = [[MusicMoreListController alloc] init];
        listVC.param = model;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 220;
}

@end
