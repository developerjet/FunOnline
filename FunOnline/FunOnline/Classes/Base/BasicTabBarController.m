//
//  BasicTabBarController.m
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "BasicTabBarController.h"
#import "BasicNavigationController.h"

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "MusicBaseViewController.h"
#import "MineViewController.h"

#import "UIImage+Extension.h"
#import "UIColor+Extension.h"


@interface BasicTabBarController ()

@end

@implementation BasicTabBarController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initChildrenController];
}

#pragma mark -

+ (void)load {
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *normalAttribute = [NSMutableDictionary dictionary];
    normalAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAttribute[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"aaaaaa"];
    [item setTitleTextAttributes:normalAttribute forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttribute = [NSMutableDictionary dictionary];
    selectedAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    selectedAttribute[NSForegroundColorAttributeName] = [UIColor colorThemeColor];
    [item setTitleTextAttributes:selectedAttribute forState:UIControlStateSelected];
}


#pragma mark -

- (void)initChildrenController
{
    HomeViewController *wallpaper = [[HomeViewController alloc] init];
    [self setupOneChildrenController:wallpaper title:@"壁纸" image:@"item-01-normal" selectedImage:@"item-01-select"];
    
    NewsViewController *news = [[NewsViewController alloc] init];
    [self setupOneChildrenController:news title:@"新闻" image:@"item-02-normal" selectedImage:@"item-02-select"];
    
    MusicBaseViewController *music = [[MusicBaseViewController alloc] init];
    [self setupOneChildrenController:music title:@"乐库" image:@"item-03-normal" selectedImage:@"item-03-select"];
    
    MineViewController *mine = [[MineViewController alloc] init];
    [self setupOneChildrenController:mine title:@"我的" image:@"item-04-normal" selectedImage:@"item-04-select"];
}

- (void)setupOneChildrenController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    BasicNavigationController *nav = [[BasicNavigationController alloc] initWithRootViewController:vc];
    
    vc.tabBarItem.title = title;
    if (((image.length) && (selectedImage.length)) > 0) { //图片存在
        vc.tabBarItem.image = [UIImage imageWithOriginalRenderingMode:image];
        vc.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:selectedImage];
    }
    
    // 添加子控制器
    [self addChildViewController:nav];
}

@end
