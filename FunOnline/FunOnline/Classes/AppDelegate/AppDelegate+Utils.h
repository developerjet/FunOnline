//
//  AppDelegate+Utils.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (Utils)

/**
 *  初始化推送SDK
 */
- (void)startGtPush:(NSDictionary *)launchOptions;

/**
 *  注册deviceToken
 */
- (void)setupPushDidRegisterDeviceToken:(NSData *)deviceToken;

/**
 *  处理推送过来的消息
 */
- (void)setupPushDidReceiveRemoteNotification:(NSDictionary *)userInfo
                       fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 *  app启动的常规设置
 */
- (void)initialAppUtil;


@end
