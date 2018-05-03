//
//  BasicNavigationController.m
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "BasicNavigationController.h"


@interface BasicNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BasicNavigationController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
}

/**
 统一设置导航栏状态栏为黑色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return  UIStatusBarStyleDefault;
}

- (void)initNavigationBar {
    
    //设置导航栏下不自动下拉
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    //禁用系统的导航侧滑返回手势,解除冲突
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //设置导航栏两侧字体颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //设置全屏返回手势的代理
    
    id target = self.interactivePopGestureRecognizer.delegate;
    
    //添加全屏滑动返回手势
    SEL backGestureSelector = NSSelectorFromString(@"handleNavigationTransition:");
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:backGestureSelector];
    [self.view addGestureRecognizer:self.pan];
    
    self.delegate = self;
}


/**
 设置导航栏样式
 */
+ (void)load {
    
    NSArray *array = [NSArray arrayWithObjects:[self class], nil]; //iOS9.0后使用
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:array];
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    navBar.titleTextAttributes = attribute;
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor colorThemeColor]];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - <UINavigationControllerDelegate>

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) { //非根控制器才能全屏滑动返回
        self.pan.enabled = YES;
        
        // 设置统一返回的按钮样式
        UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_return" highlightImg:@"icon_return" target:self action:@selector(pop)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        //非根控制器隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }else {
        //手势不可用
        self.pan.enabled = NO;
    }
    
    //正式跳转
    [super pushViewController:viewController animated:animated];
    
    if (@available(iOS 11.0, *)){
        // 修改tabBar的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

/**
 返回&出栈
 */
- (void)pop {
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self popViewControllerAnimated:YES];
}


@end
