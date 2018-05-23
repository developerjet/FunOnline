//
//  PictureFavoriteViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "PictureFavoriteController.h"
#import "WallPaperCollectionCell.h"
#import "CommentViewController.h"
#import "BasicTabBarController.h"

static int column = 2;
static NSString *const kPictureCellReuseIdentifier = @"kPictureCellReuseIdentifier";

@interface PictureFavoriteController ()

/** 已收藏的图片数据 */
@property (nonatomic, strong) NSMutableArray *pictureObjects;

@end

@implementation PictureFavoriteController

#pragma mark - Lazys

- (NSMutableArray *)pictureObjects
{
    if (!_pictureObjects) {
        
        _pictureObjects = [NSMutableArray array];
    }
    return _pictureObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubview];
    [NC addObserver:self selector:@selector(showRefresh) name:NC_Reload_Picture object:nil];
}

- (void)initSubview {
    
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 88) : (SCREEN_HEIGHT - 64);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kPictureCellReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self showRefresh];
}

- (void)showRefresh
{
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadingPicture];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadingPicture
{
    if ([CacheManager sharedManager].imageStarGroup ||
        [CacheManager sharedManager].imageStarGroup.count) {
        
        if (self.pictureObjects.count) {
            [self.pictureObjects removeAllObjects];
        }
        [self.pictureObjects addObjectsFromArray:[CacheManager sharedManager].imageStarGroup];
        [self endRefreshing];
        
        [self.collectionView reloadData];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pictureObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPictureCellReuseIdentifier forIndexPath:indexPath];
    if (self.pictureObjects.count > indexPath.row) {
        cell.model = self.pictureObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.pictureObjects.count > indexPath.row) {
        WallPaperModel *model = self.pictureObjects[indexPath.row];
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.model = model;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth  = (SCREEN_WIDTH-(column + 1) * spacing) / column;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
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
        
        [self popToHome];
    });
}

- (void)popToHome {
    
    BasicTabBarController *tabBar = (BasicTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
