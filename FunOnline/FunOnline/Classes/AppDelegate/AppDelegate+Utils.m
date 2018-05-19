//
//  AppDelegate+Utils.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate+Utils.h"
#import <IQKeyboardManager.h>
#import <AFNetworking.h>

#ifdef DEBUG
#define kGtAppId           @"LRXdu2zBbr7LlFgpmOlxT9"
#define kGtAppKey          @"ELYXgbGb5x93KzjVgAxUoA"
#define kGtAppSecret       @"iTJNX0TTz09jZq8zmoun8"
#else
#define kGtAppId           @"By3KWhQXle8wyGPdwnkzQ9"
#define kGtAppKey          @"T8VSQE13Gm8NNrpXYwnlx2"
#define kGtAppSecret       @"1YAtuauCD879eO5S9nCbu2"
#endif

@implementation AppDelegate (Utils)

//#pragma mark - 初始化SDK
//- (void)startGtPush:(NSDictionary *)launchOptions {
//
//    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
//    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
//    // 注册 APNs
//    [self registerRemoteNotification];
//}
//
///** 注册 APNs */
//- (void)registerRemoteNotification {
//    /*
//     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
//     */
//
//    /*
//     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
//     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
//     */
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
//            if (!error) {
//                NSLog(@"request authorization succeeded!");
//            }
//        }];
//
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#else // Xcode 7编译会调用
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#endif
//    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
//}
//
//- (void)setupPushDidRegisterDeviceToken:(NSData *)deviceToken {
//
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
//
//    // 向个推服务器注册deviceToken
//    [GeTuiSdk registerDeviceToken:token];
//}
//
//
//#pragma mark - Push UserInfo Handle
//- (void)setupPushDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    // 将收到的APNs信息传给个推统计
//    [GeTuiSdk handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
////  iOS 10: App在前台获取到通知
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//
//    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
//
//    if (notification.request.content.userInfo) {
//
//        [self handlePushWithUserInfo:notification.request.content.userInfo];
//    }
//
//    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
//
//
////  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//
//    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
//
//    if (response.notification.request.content.userInfo) {
//
//        [self handlePushWithUserInfo:response.notification.request.content.userInfo];
//    }
//
//    // [ GTSdk ]：将收到的APNs信息传给个推统计
//    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
//
//    completionHandler();
//}
//
///** SDK收到透传消息回调 */
//- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
//    //收到个推消息
//    NSString *payloadMsg = nil;
//    if (payloadData) {
//        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
//    }
//
//    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
//    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
//}


/** 自定义消息推送处理 */
- (void)handlePushWithUserInfo:(NSDictionary *)userInfo {}



#pragma mark - AppConfig
- (void)initialAppUtil
{
    [self startNetState];
    [self appearanceSetup];
    [self configIQManager];
}

- (void)configIQManager
{
    [IQKeyboardManager sharedManager].enable = YES; // 控制整个功能是否启用
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
}

/**
 *  iOS 11 tableView的统一适配
 */
- (void)appearanceSetup {
    
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - network state
- (void)startNetState {
    __block BOOL isStatus = NO;
    
    // 开启网络指示器
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //[XDHub showFailWithStatus:@"未知网络"];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                [XDProgressHUD showHUDWithText:@"当前网络已断开，请检查联网设置" hideDelay:1.5];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //[XDHub showSuccessWithStatus:@"已切换到3G|4G网络"];
                isStatus = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //[XDHub showSuccessWithStatus:@"已连接到WiFi网络"];
                isStatus = YES;
                break;
                
            default:
                break;
        }
        
        NSLog(@"isStatus --- %@", isStatus ? @"YES": @"NO");
    }];
    
    [manager startMonitoring];
}

@end

