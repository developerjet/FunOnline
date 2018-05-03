//
//  FavoriteViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FavoriteViewController.h"
#import "LKSegmentItemBar.h"

@interface FavoriteViewController ()<LKSegmentItemBarDelegate>

@property (nonatomic, strong) NSArray *childObjects;
@property (nonatomic, strong) NSArray *titleObjects;

@property (nonatomic, strong) LKSegmentItemBar *segmenItemView;
@property (nonatomic, strong) UIScrollView     *itemScrollView;

@end

@implementation FavoriteViewController

#pragma mark - Lazys

- (NSArray *)childObjects
{
    if (!_childObjects) {
        
        _childObjects = @[
                          @"PictureFavoriteController",
                          @"NewsFavoriteController"
                          ];
    }
    return _childObjects;
}

- (NSArray *)titleObjects
{
    if (!_titleObjects) {
        
        _titleObjects = @[@"图片", @"新闻"];
    }
    return _titleObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavItem];
    [self initSubview];
}

- (void)initNavItem
{
    self.segmenItemView = [[LKSegmentItemBar alloc] initWithFrame:CGRectMake(0, 0, 120, 50)
                                                     segmentItems:self.titleObjects];
    self.segmenItemView.delegate = self;
    self.navigationItem.titleView = self.segmenItemView;
}

- (void)initSubview
{
    self.itemScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.itemScrollView.delegate = self;
    self.itemScrollView.pagingEnabled = YES;
    self.itemScrollView.showsVerticalScrollIndicator = YES;
    self.itemScrollView.showsHorizontalScrollIndicator = YES;
    self.itemScrollView.backgroundColor = [UIColor whiteColor];
    self.itemScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.childObjects.count, 0);
    [self.view addSubview:self.itemScrollView];
    
    for (NSInteger idx = 0; idx < self.childObjects.count; idx++) {
        UIViewController *vc = [[NSClassFromString(self.childObjects[idx]) alloc] init];
        vc.title = self.titleObjects[idx];
        //当执行这段代码addChildViewController，不会执行该vc的viewDidLoad
        [self addChildViewController:vc];
    }
    
    // 进入主控制器加载第第一个页面
    [self scrollViewDidEndScrollingAnimation:self.itemScrollView];
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
    [self.segmenItemView scrolling:index];
    
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

#pragma mark - LKSegmentItemBarDelegate

- (void)segment:(LKSegmentItemBar *)segment DidSelectItemAtIndex:(NSInteger)index
{
    CGPoint point = CGPointMake(index * self.itemScrollView.frame.size.width, self.itemScrollView.contentOffset.y);
    [self.itemScrollView setContentOffset:point animated:YES];
}

@end
