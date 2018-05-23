//
//  ViewController.m
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

#pragma mark - Lazy

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGFloat height = iPhoneX ? (SCREEN_HEIGHT-88) : (SCREEN_HEIGHT-64);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor viewBackGroundColor];
        _tableView.separatorColor = [UIColor colorBoardLineColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{    
    if (!_collectionView) {
        CustomeViewLayout *flowLayout = [[CustomeViewLayout alloc] init]; //瀑布流布局
        flowLayout.columnCount = maxColumn; //共多少列
        flowLayout.columnSpacing = spacing; //列间距
        flowLayout.rowSpacing = spacing; //行间距
        //设置collectionView整体的上下左右之间的间距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, spacing, spacing, spacing);
        flowLayout.delegate = self;
        
        CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 83) : (SCREEN_HEIGHT - 49);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)endRefreshing {
    [XDProgressHUD hideHUD]; // 移除菊花
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if ([self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header endRefreshing];
    }
    if ([self.collectionView.mj_footer isRefreshing]) {
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - Life Cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    self.tableView.emptyDataSetSource   = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.collectionView.emptyDataSetSource   = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    [NC addObserver:self selector:@selector(recoverRefresh) name:NC_Reload_Home object:nil];
    [NC addObserver:self selector:@selector(recoverRefresh) name:NC_Reload_Music object:nil];
}

- (void)recoverRefresh
{
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    if (![self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points(状态栏不隐藏)
    // 也可以不写，系统默认是UIEdgeInsetsMake(10, 0, 34, 0);
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - <DZNEmptyDataSetSource>
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"icon_loading_image"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"请点击重试哟~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor colorThemeColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}


#pragma mark - <CustomViewLayoutDelegate>
- (CGFloat)customFallLayout:(CustomeViewLayout *)customFallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = ((SCREEN_WIDTH - (maxColumn + 1) * spacing) / maxColumn) - 20;
    return arc4random() % 30 + width;
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [weakSelf customReload];
    });
}

- (void)customReload {
    
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    if (![self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return SCREEN_HEIGHT * 0.2;
}

#pragma mark -
#pragma mark - <UINavigationControllerDelegate iPhoneX适配处理>
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![[[UIDevice currentDevice] model] isEqualToString: @"iPhone X"]) {
        return;
    }
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - 83)) {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 83;
        self.tabBarController.tabBar.frame = frame;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [NC removeObserver:self name:NC_Reload_Home object:nil];
    [NC removeObserver:self name:NC_Reload_Music object:nil];
}

@end
