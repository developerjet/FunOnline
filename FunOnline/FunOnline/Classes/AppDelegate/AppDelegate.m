//
//  AppDelegate.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "BasicTabBarController.h"
#import "BasicNavigationController.h"
#import "AppDelegate+Utils.h"

#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initAvAudioItem];
    [self initWindownRoot];
    [self initialAppUtil];
    
    return YES;
}


- (void)initAvAudioItem
{    
    // AudioSessionInitialize用于控制打断
    // 这种方式后台，可以连续播放非网络请求歌曲，遇到网络请求歌曲就废,需要后台申请task
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
    if (!success) {
        return;
    }
    
    NSError *activationError = nil;
    success = [session setActive:YES error:&activationError];
    
    if (!success) {
        return;
    }
}

- (void)initWindownRoot
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BasicTabBarController *tabBar = [[BasicTabBarController alloc] init];
    self.window.rootViewController = tabBar;
    
    [self.window makeKeyAndVisible]; //打开窗口
}

- (UINavigationController *)currentNav {
    
    UITabBarController *tabBar = (BasicTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (![tabBar isKindOfClass:[UITabBarController class]]) return nil;
    
    UINavigationController *nav = (BasicNavigationController *)tabBar.selectedViewController;
    
    return nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


/**
 *  程序进入后台，继续播放当前音乐
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    UIBackgroundTaskIdentifier taskID = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    if (taskID != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:taskID];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
