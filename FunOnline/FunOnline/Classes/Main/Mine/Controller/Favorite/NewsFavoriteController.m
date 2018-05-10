//
//  NewsFavoriteViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NewsFavoriteController.h"
#import "WebBrowseViewController.h"
#import "BasicTabBarController.h"
#import "NewsTableViewCell.h"

static NSString *const kNewsFavoriteCellIdentifier = @"kNewsFavoriteCellIdentifier";

@interface NewsFavoriteController ()
/// 新闻的收藏数据
@property (nonatomic, strong) NSMutableArray *cacheObjects;

@property (nonatomic, strong) NewsModel *jumpModel;

@end

@implementation NewsFavoriteController

- (NSMutableArray *)cacheObjects
{
    if (!_cacheObjects) {
        
        _cacheObjects = [NSMutableArray array];
    }
    return _cacheObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubview];
    [NC addObserver:self selector:@selector(reloadTable) name:NC_Reload_News object:nil];
}

- (void)initSubview
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsFavoriteCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self reloadTable];
}

- (void)reloadTable
{
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadingCaches];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadingCaches
{
    if ([CacheManager sharedManager].newsStarGroup ||
        [CacheManager sharedManager].newsStarGroup.count) {
        
        if (self.cacheObjects.count) {
            [self.cacheObjects removeAllObjects];
        }
        [self.cacheObjects addObjectsFromArray:[CacheManager sharedManager].newsStarGroup];
        [self endRefreshing];
        
        [self.tableView reloadData];
    }
}

#pragma mark - table for data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cacheObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsFavoriteCellIdentifier];
    if (self.cacheObjects.count > indexPath.row) {
        cell.model = self.cacheObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - table for delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cacheObjects.count > indexPath.row) {
        self.jumpModel = self.cacheObjects[indexPath.row];
        [self performSelector:@selector(afterJump) withObject:nil afterDelay:0.25];
    }
}

// 延迟跳转
- (void)afterJump
{
    WebBrowseViewController *browseVC = [[WebBrowseViewController alloc] init];
    browseVC.model       = self.jumpModel;
    browseVC.urlString   = self.jumpModel.link;
    browseVC.titleString = self.jumpModel.title;
    [self.navigationController pushViewController:browseVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 141;
}

#pragma mark - <DZNEmptyDataSetDataSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"赶快去收藏吧~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor colorThemeColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self popToNews];
    });
}

- (void)popToNews {
    
    BasicTabBarController *tabBar = (BasicTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.selectedIndex = 1; // 新闻界面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
