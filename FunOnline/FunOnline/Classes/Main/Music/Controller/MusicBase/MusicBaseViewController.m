//
//  MusicBaseViewController.m
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicBaseViewController.h"
#import "LKSegmentItemBar.h"

@interface MusicBaseViewController ()<LKSegmentItemBarDelegate>

@property (nonatomic, strong) NSArray *subControllers;
@property (nonatomic, strong) NSArray *titleObjects;

@property (nonatomic, strong) LKSegmentItemBar *segmenItemView;
@property (nonatomic, strong) UIScrollView     *subViewScroll;
@property (nonatomic, assign) NSInteger        currentIndex;

@end

@implementation MusicBaseViewController

#pragma mark - Lazys

- (NSArray *)subControllers {
    
    if (!_subControllers) {
        _subControllers = @[
                            @"MusicHotViewController",
                            @"MusicClassifyController"
                            ];
    }
    return _subControllers;
}

- (NSArray *)titleObjects {
    
    if (!_titleObjects) {
        _titleObjects = @[@"热门", @"乐库"];
    }
    return _titleObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentIndex = 0;
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
    self.subViewScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.subViewScroll.delegate = self;
    self.subViewScroll.pagingEnabled = YES;
    self.subViewScroll.showsVerticalScrollIndicator = YES;
    self.subViewScroll.showsHorizontalScrollIndicator = YES;
    self.subViewScroll.backgroundColor = [UIColor whiteColor];
    self.subViewScroll.contentSize = CGSizeMake(SCREEN_WIDTH * self.subControllers.count, 0);
    [self.view addSubview:self.subViewScroll];
    
    for (NSInteger idx = 0; idx < self.subControllers.count; idx++) {
        UIViewController *vc = [[NSClassFromString(self.subControllers[idx]) alloc] init];
        vc.title = self.titleObjects[idx];
        //当执行这段代码addChildViewController，不会执行该vc的viewDidLoad
        [self addChildViewController:vc];
    }
    
    // 进入主控制器加载第第一个页面
    [self scrollViewDidEndScrollingAnimation:self.subViewScroll];
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
    CGPoint point = CGPointMake(index * self.subViewScroll.frame.size.width, self.subViewScroll.contentOffset.y);
    [self.subViewScroll setContentOffset:point animated:YES];

    if (_currentIndex == index) {
        [NC postNotificationName:NC_Reload_Music object:nil userInfo:nil]; //再次刷新通知
    }
    _currentIndex = index;
}

@end
