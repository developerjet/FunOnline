//
//  RecentViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NewWallPaperController.h"
#import "WallPaperCollectionCell.h"
#import "CommentViewController.h"


#define column  2
static NSString *const kNewWallPaperCellIdentifier = @"kNewWallPaperCellIdentifier";

@interface NewWallPaperController ()

@property (nonatomic, strong) NSMutableArray *resultObjects;

@end

@implementation NewWallPaperController

#pragma mark - Lazy

- (NSMutableArray *)resultObjects
{
    if (!_resultObjects) {
        
        _resultObjects = [NSMutableArray array];
    }
    return _resultObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initRefresh];
}

- (void)initRefresh
{
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT-88-83) : (SCREEN_HEIGHT-64-49);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kNewWallPaperCellIdentifier];
    [self.view addSubview:self.collectionView];
    
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf showRefreshing:weakSelf.page];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)showRefreshing:(NSInteger)page {
    
    NSDictionary *params = @{
                             @"order": @"new",
                             @"adult": @"false",
                             @"first": @(page),
                             @"limit": @(30)
                             };
    
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:url_newwp parameters:params success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"success"]) {
            NSArray *newObjects = [WallPaperModel mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"wallpaper"]];
            
            if (page == 1) {
                [self.resultObjects removeAllObjects];
                self.collectionView.mj_header.state = MJRefreshStateIdle;
            }
            
            [self.resultObjects addObjectsFromArray:newObjects];
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
       
        [self endRefreshing];
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.resultObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewWallPaperCellIdentifier forIndexPath:indexPath];
    if (self.resultObjects.count > indexPath.row) {
        cell.model = self.resultObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.resultObjects.count > indexPath.row) {
        WallPaperModel *model = self.resultObjects[indexPath.row];
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.model = model;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

@end
