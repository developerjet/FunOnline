//
//  SearchResultController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/8.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchHistoryViewController.h"
#import "BasicNavigationController.h"
#import "WallPaperCollectionCell.h"
#import "CommentViewController.h"
#import "SDPhotoBrowser.h"

static NSString *const kSearchResultIdentifier = @"kSearchResultIdentifier";

@interface SearchResultViewController ()<SDPhotoBrowserDelegate, WallPaperCellDelegate>
/// 搜索结果
@property (nonatomic, strong) NSMutableArray *searchResults;
/// 浏览图片数组
@property (nonatomic, strong) NSMutableArray *browserGroup;

@end

@implementation SearchResultViewController

- (NSMutableArray *)searchResults
{
    if (!_searchResults) {
        
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

- (NSMutableArray *)browserGroup
{
    if (!_browserGroup) {
        
        _browserGroup = [NSMutableArray arrayWithCapacity:0];
    }
    return _browserGroup;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [self.value stringByRemovingPercentEncoding];
    
    [self configSubview];
    [self loadingResult];
}

- (void)configSubview
{
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 88) : (SCREEN_HEIGHT - 64);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kSearchResultIdentifier];
    [self.view addSubview:self.collectionView];
    
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadingResult];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadingResult
{
    NSDictionary *params = @{
                             @"adult": @"false",
                             @"version": @"148",
                             @"channel": @"UCshangdian",
                             };
    
    NSString *urlStr = [NSString stringWithFormat:@"http://so.picasso.adesk.com/v1/search/all/resource/%@?", self.value];
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:urlStr parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj && ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        NSArray *objects = responseObj[@"res"][@"search"];
        
        if (objects && objects.count == 5) {
            NSDictionary *dict = objects[1]; //获取壁纸
            self.searchResults = [WallPaperModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
            
            for (int idx = 0; idx < self.searchResults.count; idx++)
            {
                WallPaperModel *item = self.searchResults[idx];
                [self.browserGroup addObject:item.img];
            }
        }
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - WallPaperCellDelegate

- (void)cell:(WallPaperCollectionCell *)cell DidSelectIndexAtItem:(WallPaperModel *)item {
    
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.model = item;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - UICollectionView For Data

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchResultIdentifier forIndexPath:indexPath];
    cell.isCheck  = YES;
    cell.delegate = self;
    if (self.searchResults.count > indexPath.row) {
        cell.model = self.searchResults[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionView For Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchResults.count > indexPath.row) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = self.browserGroup.count;
        photoBrowser.sourceImagesContainerView = self.collectionView;
        [photoBrowser show];
    }
}

#pragma mark - <SDPhotoBrowserDelegate>

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.browserGroup[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
