//
//  ClassifyViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "ClassifyViewController.h"
#import "WallPaperCollectionCell.h"
#import "ClassifyDetailController.h"
#import "WallPaperModel.h"

#define column 2
static NSString *const kClassifyReuseIdentifier = @"kClassifyReuseIdentifier";

@interface ClassifyViewController ()

@property (nonatomic, strong) NSMutableArray *classifyGroup;

@end

@implementation ClassifyViewController

#pragma mark - Lazy

- (NSMutableArray *)classifyGroup
{
    if (!_classifyGroup) {
        
        _classifyGroup = [NSMutableArray array];
    }
    return _classifyGroup;
}

#pragma mark - Cycle life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    [self loadClassify];
}

- (void)initSubviews
{
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT-88-83) : (SCREEN_HEIGHT-64-49);
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.collectionView registerClass:[WallPaperCollectionCell class] forCellWithReuseIdentifier:kClassifyReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    WeakSelf;
    self.collectionView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadClassify];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadClassify
{
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:url_classify parameters:nil success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"success"]) {
            
             self.classifyGroup = [WallPaperModel mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"category"]];
            
            if (self.classifyGroup.count) {
                [self.collectionView reloadData];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.classifyGroup.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WallPaperCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClassifyReuseIdentifier forIndexPath:indexPath];
    if (self.classifyGroup.count > indexPath.row) {
        cell.model = self.classifyGroup[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.classifyGroup.count > indexPath.row) {
        WallPaperModel *model = self.classifyGroup[indexPath.row];
        ClassifyDetailController *detailVC = [[ClassifyDetailController alloc] init];
        detailVC.categoryID = model.Id;
        detailVC.titleString = model.name;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
