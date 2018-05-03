//
//  PublicSearchViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/8.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "SearchResultViewController.h"
#import "BasicNavigationController.h"
#import "MClassSearchBar.h"
#import "AppDelegate.h"

static NSString *objectKey = @"kIsFirsterEnter";

@interface SearchHistoryViewController()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray  *dataObjects;
@property (nonatomic, strong) MClassSearchBar *searchBar;
@property (nonatomic, strong) UIButton        *clearButton;
@property (nonatomic,   copy) NSString        *searchValue;

@end

@implementation SearchHistoryViewController

#pragma mark - Lazy

- (void)refreshResult {
    if (!self.dataObjects) {
        self.dataObjects = [NSMutableArray arrayWithCapacity:0];
    }else {
        [self.dataObjects removeAllObjects];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[UD objectForKey:UD_SEARCH_IMAGE]];
    if (arr && arr.count > 0) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataObjects addObject:arr[arr.count - 1 - idx]];
        }];
    }
    
    if (!self.dataObjects || self.dataObjects.count <= 0) {
        self.clearButton.hidden = YES;
    }else {
        self.clearButton.hidden = NO;
    }
    
    [self.tableView reloadData];
}

// 判断是否第一次进入界面
- (BOOL)isFirsterEnter {
    BOOL isEnter = NO;
    isEnter = [UD objectForKey:objectKey];
    if (!isEnter) {
        [UD setBool:YES forKey:objectKey];
        [UD synchronize];
    }
    return !isEnter;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshResult];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索";
    
    [self showSearchTips];
    [self configSubview];
}

- (void)configSubview
{
    CGFloat width = SCREEN_WIDTH * 0.66;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    
    MClassSearchBar *searchBar = [[MClassSearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    self.searchBar = searchBar;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"search_white"
                                                               highlightImg:@"search_white"
                                                                     target:self
                                                                     action:@selector(loadResult)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.clearButton = [[UIButton alloc] initWithFrame:footerView.bounds];
    self.clearButton.hidden = YES; //默认隐藏
    self.clearButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.clearButton setTitle:@"清除所有" forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.clearButton setImage:[UIImage imageNamed:@"icon_music_clear"] forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor colorWithHexString:@"989898"] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.clearButton];
    self.tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.tableView];
}

- (void)showSearchTips
{
    if ([self isFirsterEnter]) {
        [LEEAlert alert].config
        .LeeTitle(@"温馨提示")
        .LeeContent(@"输入关键词或点击搜索记录可以加载图片信息")
        .LeeAction(@"OK", ^{
            
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleOrientationTop) //这里设置打开动画样式的方向为上 以及淡入效果.
        .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleOrientationBottom) //这里设置关闭动画样式的方向为下 以及淡出效果
        .LeeShow();
    }
}

- (void)loadResult {
    
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)clearEvent:(UIButton *)sender {
    if (!self.dataObjects.count) {
        [XDProgressHUD showHUDWithText:@"当前没有搜索记录" hideDelay:1.0];
        return;
    }
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeTitle(@"确认删除全部历史记录?")
    .LeeAction(@"NO", ^{
        // 点击事件Block
    })
    .LeeAction(@"YES", ^{
        [weakSelf.dataObjects removeAllObjects];
        [weakSelf svaeFileObjects:@[]];
    })
    .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
    .LeeShow();
}

// 延迟跳转
- (void)afterJump {
    [self reloadSearchResultData];
    
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.value = [self.searchValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark - Search For Handel

- (void)reloadSearchResultData {
    
    NSMutableArray *searchResultArr = [NSMutableArray arrayWithArray:[UD objectForKey:UD_SEARCH_IMAGE]];
    
    if (self.searchBar.text.length>0 && ![[NSObject NullToEmpty:self.searchBar.text] isEqualToString:@""]) {
        if (searchResultArr && searchResultArr.count>0) {
            searchResultArr = (NSMutableArray *)[self relpeaseObjects:searchResultArr];  //先判断当前数组中是否包含这个元素，包含就删掉然后插到第一个，不包含就删除最后一个再插到第一个位置
            if ([searchResultArr count] >= 10) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:searchResultArr];
                [searchResultArr removeAllObjects];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ((idx+1)<arr.count) {
                        [searchResultArr addObject:arr[idx+1]];
                    }
                }];
                [searchResultArr addObject:self.searchBar.text];
            }else{
                [searchResultArr addObject:self.searchBar.text];
            }
        }else{
            [searchResultArr addObject:self.searchBar.text];
        }
    }else{
        return;
    }
    
    [self svaeFileObjects:searchResultArr];
}

- (NSArray *)relpeaseObjects:(NSArray *)objects {
    
    NSMutableArray *newObjects = [[NSMutableArray alloc] initWithArray:objects];
    if ([objects containsObject:self.searchBar.text]) {
        NSInteger row = [objects indexOfObject:self.searchBar.text];
        [newObjects removeObjectAtIndex:row];
        newObjects.count == 10 ? [newObjects addObject:@""] : newObjects;
    }
    return newObjects;
}

- (void)svaeFileObjects:(NSArray *)objects
{
    [UD setObject:objects forKey:UD_SEARCH_IMAGE];
    [UD synchronize];
    // 重刷列表
    [self refreshResult];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    if (!self.searchBar.text || [self.searchBar.text isEqualToString:@""]) {
        [XDProgressHUD showHUDWithText:@"搜索关键词不能为空" hideDelay:1.5];
        return;
    }
    
    self.searchValue = self.searchBar.text;
    [self performSelector:@selector(afterJump) withObject:nil afterDelay:0.25];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

#pragma mark - UITableView For Data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCellIdentifier"];
        cell.textLabel.textColor = COLORHEX(@"323232");
    }
    
    self.clearButton.hidden = !self.dataObjects.count;
    
    if (self.dataObjects.count > indexPath.row) {
        
        cell.textLabel.text = self.dataObjects[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableView For Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.dataObjects.count > indexPath.row) {
        self.searchValue = self.dataObjects[indexPath.row];
        self.searchBar.text = self.searchValue;
    }
    [self performSelector:@selector(afterJump) withObject:nil afterDelay:0.25];
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"暂无搜索历史~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor colorThemeColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

@end
