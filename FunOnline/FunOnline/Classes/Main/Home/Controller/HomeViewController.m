//
//  WallpaperViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchHistoryViewController.h"
#import "LKSegmentItemBar.h"

@interface HomeViewController ()
/** 容器滚动视图 */
@property (nonatomic, strong) UIScrollView *mainScrollView;
/** 标题 */
@property (nonatomic, strong) NSArray *titleGroup;
/** 子控制器 */
@property (nonatomic, strong) NSArray *childenGroup;
/** 顶部菜单选项 */
@property (nonatomic, strong) LKSegmentItemBar *segmentItem;
/** 记录点击的索引 */
@property (nonatomic, assign) NSInteger scrollRecord;

@end

@implementation HomeViewController

#pragma mark - Lazys

- (NSArray *)titleGroup
{
    if (!_titleGroup) {
        
        _titleGroup = @[@"推荐", @"分类", @"最新"];
    }
    return _titleGroup;
}

- (NSArray *)childenGroup
{
    if (!_childenGroup) {
        
        _childenGroup = @[
                          @"HotGroupViewController",
                          @"ClassifyViewController",
                          @"NewWallPaperController"
                          ];
    }
    return _childenGroup;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"壁纸";
    self.scrollRecord = 0;
    
    [self initNavitem];
    [self initSubview];
}

- (void)initNavitem
{
    self.segmentItem = [[LKSegmentItemBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50)
                                                  segmentItems:self.titleGroup];
    self.navigationItem.titleView = self.segmentItem;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_search" highlightImg:@"icon_search" target:self action:@selector(jumpSearch)];
}

- (void)initSubview
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES; //设置分页
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(self.childenGroup.count * width, self.view.frame.size.height);
    [self.view addSubview:self.mainScrollView];
    
    for (NSInteger idx = 0; idx < self.childenGroup.count; idx++) {
        UIViewController *vc = [[NSClassFromString(self.childenGroup[idx]) alloc] init];
        vc.title = self.titleGroup[idx];
        //当执行这段代码addChildViewController，不会执行该vc的viewDidLoad
        [self addChildViewController:vc];
    }
    
    //进入主控制器加载第第一个页面
    [self scrollViewDidEndScrollingAnimation:self.mainScrollView];
    
    __weak typeof(self) weakSelf = self;
    self.segmentItem.didFinishedBlock = ^(NSInteger index) {
        CGPoint point = CGPointMake(index * self.mainScrollView.frame.size.width, weakSelf.mainScrollView.contentOffset.y);
        [weakSelf.mainScrollView setContentOffset:point animated:YES];
        if (weakSelf.scrollRecord == index) {
            [NC postNotificationName:NC_Reload_Home object:nil];
        }
        weakSelf.scrollRecord = index;
    };
}

#pragma mark - jumps

- (void)jumpSearch
{
    SearchHistoryViewController *searchVC = [[SearchHistoryViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
//动画结束调用代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat width  = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //获取索引值
    NSInteger index = offsetX / width;
    
    //索引值联动SegmentView
    [self.segmentItem scrolling:index];
    
    //根据索引值返回vc的引用
    UIViewController *childVC = self.childViewControllers[index];
    
    //判断当前vc是否执行过viewDidLoad
    if ([childVC isViewLoaded]) return;
    
    //设置子控制器view大小
    childVC.view.frame = CGRectMake(offsetX, 0, scrollView.frame.size.width, height);
    
    //将子控制器的view加到ScrollView
    [scrollView addSubview:childVC.view];
}

//减速结束时调用加载子控制器view的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
