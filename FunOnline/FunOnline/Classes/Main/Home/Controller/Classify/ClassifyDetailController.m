//
//  ClassifyDetailController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/8.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "ClassifyDetailController.h"
#import "WallPaperCollectionCell.h"
#import "CommentViewController.h"
#import "SDPhotoBrowser.h"

#define column  2
static NSString *const kDetailCellReuseIdentifier = @"kDetailCellReuseIdentifier";

@interface ClassifyDetailController ()<SDPhotoBrowserDelegate, WallPaperCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *browserImages;

@end

@implementation ClassifyDetailController

#pragma mark - Lazy

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)browserImages
{
    if (!_browserImages) {
        
        _browserImages = [NSMutableArray arrayWithCapacity:0];
    }
    return _browserImages;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleString;
    
    [self initRefresh];
}

- (void)initRefresh
{
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 88) : (SCREEN_HEIGHT - 64);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kDetailCellReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadingDetail:weakSelf.page];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadingDetail:(NSInteger)page
{
    NSDictionary *params = @{
                             @"order": @"new",
                             @"adult": @"false",
                             @"first": @(page),
                             @"limit": @(30)
                             };
    
    NSString *urlStr = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/wallpaper/category/%@/wallpaper", self.categoryID];
    
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:urlStr parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"success"]) {
            NSArray *newObjects = [WallPaperModel mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"wallpaper"]];

            if (page == 1) {
                [self.dataSource removeAllObjects];
                self.tableView.mj_header.state = MJRefreshStateIdle;
            }
            
            for (int idx = 0; idx < newObjects.count; idx++)
            {
                WallPaperModel *item = newObjects[idx];
                [self.browserImages addObject:item.img];
            }
            
            [self.dataSource addObjectsFromArray:newObjects];
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <WallPaperCellDelegate>
- (void)cell:(WallPaperCollectionCell *)cell DidSelectIndexAtItem:(WallPaperModel *)item
{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.model = item;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailCellReuseIdentifier forIndexPath:indexPath];
    cell.isCheck  = YES;
    cell.delegate = self;
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = self.browserImages.count;
        photoBrowser.sourceImagesContainerView = self.collectionView;
        [photoBrowser show];
    }
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    NSString *urlStr = [self.browserImages[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
