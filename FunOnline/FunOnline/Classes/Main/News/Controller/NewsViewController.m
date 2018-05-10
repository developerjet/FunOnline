//
//  NewsViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "WebBrowseViewController.h"
#import "PagingScrollMenu.h"

static NSString *const kNewsCellReuseIdentifier = @"kNewsCellReuseIdentifier";

@interface NewsViewController ()<PagingScrollMenuDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) PagingScrollMenu *scrollMenu;
@property (nonatomic, strong) NSMutableArray *newsObjects;
@property (nonatomic, strong) NSArray *titleObjects;
@property (nonatomic, strong) NSArray *idsObjects;

@property (nonatomic, strong) NewsModel *selectModel;
@property (nonatomic, strong) UIButton  *reachButton;
@property (nonatomic, strong) NSString  *categoryId;

@property (nonatomic, assign) NSInteger scrollIndex;
@property (nonatomic, assign) NSInteger count;

@end

@implementation NewsViewController

- (NSMutableArray *)newsObjects
{
    if (!_newsObjects) {
        
        _newsObjects = [[NSMutableArray alloc] init];
    }
    return _newsObjects;
}

- (NSArray *)titleObjects
{
    if (!_titleObjects) {
        
        _titleObjects = @[@"全部", @"头条",@"快讯", @"游戏", @"应用",@"业界", @"Jobs",@"库克",@"炫配",@"活动",@"ipone技巧", @"iPad技巧", @"Mac技巧",@"iTunes技巧"];
    }
    return _titleObjects;
}

- (NSArray *)idsObjects
{
    if (!_idsObjects) {
        
        _idsObjects = @[@"0", @"9999",@"1",@"11",@"1967",@"4",@"43",@"2634",@"3",@"8", @"6", @"5", @"230", @"12"];
    }
    return _idsObjects;
}

- (UIButton *)reachButton
{
    if (!_reachButton) {
        _reachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reachButton setImage:[UIImage imageNamed:@"icon_blue_top"] forState:UIControlStateNormal];
        _reachButton.hidden = YES; //默认隐藏
        CGFloat buttonY = iPhoneX ? self.view.mj_h - 266 : self.view.mj_h - 183;
        _reachButton.frame = CGRectMake(self.view.frame.size.width - 70, buttonY, 60, 60);
        [_reachButton addTarget:self action:@selector(scrollTop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reachButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新闻";
    [self configSubview];
}

- (void)configSubview
{
    self.categoryId  = @"0"; //默认加载全部
    self.scrollIndex = 0;
    
    PagingScrollMenu *scrollMenu = [[PagingScrollMenu alloc] initWithOrigin:CGPointMake(0, 0) height:40 titles:self.titleObjects];
    scrollMenu.delegate = self;
    [self.view addSubview:scrollMenu];
    self.scrollMenu = scrollMenu;
    
    CGFloat tableY = CGRectGetMaxY(scrollMenu.frame);
    CGFloat tableH = iPhoneX ? (SCREEN_HEIGHT-88-83-tableY) : (SCREEN_HEIGHT-49-64-tableY);
    self.tableView.frame = CGRectMake(0, tableY, SCREEN_WIDTH, tableH);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:kNewsCellReuseIdentifier];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.reachButton];
    
    // 添加轻扫手势
    [self addLeftSwipGesture:self.tableView];
    [self addRightSwipGesture:self.tableView];
    
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.count = 16;
        [weakSelf showRefreshing:weakSelf.count];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.count += 16;
        if (weakSelf.newsObjects.count) {
            [weakSelf.newsObjects removeAllObjects];
        }
        [weakSelf showRefreshing:weakSelf.count];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)showRefreshing:(NSInteger)page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@category_ids=%@&max_id=0&count=%ld", url_news, self.categoryId,  page];
    
    WeakSelf;
    [[RequestManager manager] startGET:urlStr parameters:nil progress:nil success:^(id  _Nonnull response) {
        [self endRefreshing];
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *jsonObject = response;
            NSArray *objects = [NewsModel mj_objectArrayWithKeyValuesArray:jsonObject];
    
            if (page == 16) {
                [weakSelf.newsObjects removeAllObjects];
                weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
            }else if (page >= 160) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [weakSelf.newsObjects addObjectsFromArray:objects];
            [weakSelf mainQueueRefresh];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endRefreshing];
    }];
}

// 主线程刷新
- (void)mainQueueRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)scrollTop:(UIButton *)sender
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - UISwipeGestureRecognizer

- (void)addLeftSwipGesture:(UIView *)view
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipEvent:)];
    // 设置方向(一个手势只能定义一个方向)
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    swip.delegate = self;
    // 视图添加手势
    [view addGestureRecognizer:swip];
}

- (void)addRightSwipGesture:(UIView *)view
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipEvent:)];
    // 设置方向(一个手势只能定义一个方向)
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    swip.delegate = self;
    // 视图添加手势
    [view addGestureRecognizer:swip];
}

- (void)swipEvent:(UISwipeGestureRecognizer *)swip {
    self.tableView.scrollEnabled = NO;
    NSTimeInterval duration = 0.75;
    
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) { //判断轻扫方向
        if (self.scrollIndex == self.idsObjects.count-1) return; // 防止crash
        self.scrollIndex++; //增加索引值
        
        CATransition *caAinimation = [CATransition animation];
        //设置动画的格式
        caAinimation.type = @"cube";
        //设置动画的方向
        caAinimation.subtype = @"fromRight";
        //设置动画的持续时间
        caAinimation.duration = duration;
        [self.view.superview.layer addAnimation:caAinimation forKey:nil];
        
    } if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.scrollIndex == 0) return;
        self.scrollIndex--;
        
        CATransition *caAinimation = [CATransition animation];
        //设置动画的格式
        caAinimation.type = @"cube";
        //设置动画的方向
        caAinimation.subtype = @"fromLeft";
        //设置动画的持续时间
        caAinimation.duration = duration;
        [self.view.superview.layer addAnimation:caAinimation forKey:nil];
    }
    
    self.categoryId = self.idsObjects[self.scrollIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
        [self.scrollMenu scrollToAtIndex:self.scrollIndex];
        self.tableView.scrollEnabled = YES;
        [self.tableView.mj_header beginRefreshing]; //重刷列表
    });
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - table for data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellReuseIdentifier];
    if (self.newsObjects.count > indexPath.row) {
        cell.model = self.newsObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - table for delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.newsObjects.count > indexPath.row) {
        NewsModel *model = self.newsObjects[indexPath.row];
        
        WebBrowseViewController *browseVC = [WebBrowseViewController new];
        browseVC.model       = model;
        browseVC.urlString   = model.link;
        browseVC.titleString = model.title;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [self.navigationController pushViewController:browseVC animated:NO];
        });
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 141;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > self.view.frame.size.height-158) {
        self.reachButton.hidden = NO;
    }else {
        self.reachButton.hidden = YES;
    }
}

#pragma mark - PagingScrollMenuDelegate

- (void)scroll:(PagingScrollMenu *)scroll didSelectItemAtIndex:(NSInteger)index {
    self.scrollIndex = index; //及时改变索引值
    
    if (self.idsObjects.count == self.titleObjects.count) {
        
        self.categoryId = self.idsObjects[index];
    }
    // 重新请求列表
    [self.tableView.mj_header beginRefreshing];
}

@end
