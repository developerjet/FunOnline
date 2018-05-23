//
//  RecommendViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "HotGroupViewController.h"
#import "WallPaperCollectionCell.h"
#import "WebBrowseViewController.h"
#import "CommentViewController.h"
#import "FingerprintLogView.h"
#import "BannerHeaderView.h"
#import "WallPaperModel.h"

static NSString *const kWallpaperCellIdentifier   = @"kWallpaperCellIdentifier";
static NSString *const kWallpaperHeaderIdentifier = @"kWallpaperHeaderIdentifier";

@interface HotGroupViewController ()<BannerHeaderViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *bannerDataGroup;
@property (nonatomic, strong) NSMutableArray *wallpaperGroup;

@end

@implementation HotGroupViewController

#pragma mark - Lazys

- (NSMutableArray *)bannerDataGroup {
    
    if (!_bannerDataGroup) {
        
        _bannerDataGroup = [NSMutableArray array];
    }
    return _bannerDataGroup;
}

- (NSMutableArray *)wallpaperGroup {
    
    if (!_wallpaperGroup) {
        
        _wallpaperGroup = [NSMutableArray array];
    }
    return _wallpaperGroup;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = spacing;
        _flowLayout.minimumInteritemSpacing = spacing;
        _flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubview];
    [self startVerify];
}

- (void)initSubview
{
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT-123-49) : (SCREEN_HEIGHT-64-49);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kWallpaperCellIdentifier];
    [self.collectionView registerClass:[BannerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWallpaperHeaderIdentifier];
    [self.view addSubview:self.collectionView];
    
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadHotObject];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)startVerify {
    //设置了指纹解锁(才须验证)
    if ([SecurityManager sharedInstance].state) {
        FingerprintLogView *logView = [[FingerprintLogView alloc] init];
        [logView show];
    }
}

- (void)loadHotObject
{
    NSDictionary *params = @{
                             @"order": @"hot",
                             @"adult": @"false",
                             @"first": @"1",
                             @"limit": @"60"
                             };
    
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:url_homeHot parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"success"]) {
            if (self.bannerDataGroup.count) {
                [self.bannerDataGroup removeAllObjects];
            }
            if (self.wallpaperGroup.count) {
                [self.wallpaperGroup removeAllObjects];
            }
            
            NSMutableArray *newBanners = [BannerModel mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"banner"]];
            NSMutableArray *newWallpapers = [WallPaperModel mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"wallpaper"]];
            [self.bannerDataGroup addObjectsFromArray:newBanners];
            [self.wallpaperGroup addObjectsFromArray:newWallpapers];
            
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

#pragma mark - <BannerHeaderViewDelegate>

- (void)banner:(BannerHeaderView *)banner didSelectIndexAtItem:(BannerModel *)item {
    
    if ([item.target containsString:@"http://"] || [item.target containsString:@"https://"]) {
        WebBrowseViewController *browseVC = [[WebBrowseViewController alloc] init];
        browseVC.titleString = item.desc;
        browseVC.urlString = item.target;
        [self.navigationController pushViewController:browseVC animated:YES];
        return;
    }
    
    WallPaperModel *model = [[WallPaperModel alloc] init];
    model.Id = item.Id;
    model.img = item.thumb;
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.model = model;
    commentVC.model.desc = item.desc;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.wallpaperGroup.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWallpaperCellIdentifier forIndexPath:indexPath];
    if (self.wallpaperGroup.count > indexPath.row) {
        cell.model = self.wallpaperGroup[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    BannerHeaderView *headeReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWallpaperHeaderIdentifier forIndexPath:indexPath];
    headeReusableView.delegate = self;
    headeReusableView.bannerModelGroup = self.bannerDataGroup;
    return headeReusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - (maxColumn + 1) * spacing) / maxColumn;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.wallpaperGroup.count > indexPath.row) {
        WallPaperModel *model = self.wallpaperGroup[indexPath.row];
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.model = model;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

@end
