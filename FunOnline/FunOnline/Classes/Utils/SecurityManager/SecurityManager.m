//
//  SecurityManager.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/4/2.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "SecurityManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

static NSString *const kTouchIDHandelKey = @"kTouchIDHandelKey";

// iOS系统版本判断
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS9 (kSystemVersion >= 9.0)

@implementation SecurityManager

#pragma mark - public method

+ (instancetype)sharedInstance {
    
    static SecurityManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[SecurityManager alloc] init];
    });
    return _shared;
}

#pragma mark - setup

- (void)openIsTouchIDWithController:(UIViewController *)controller message:(NSString *)message block:(TouchIdDidResultBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 设置TouchID操作(开启&关闭)
            [self createAuthenWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                   state:[SecurityManager sharedInstance].state
                                    type:TouchIDHandelType_Setting
                         didTouchIDBlock:block];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            !block?:block(NO, @"已取消");
        }]];
        
        [controller presentViewController:alert animated:YES completion:nil];
    });
}


#pragma mark - validate

- (void)verifyTouchIDWithBlock:(TouchIdDidResultBlock)block
{
    [self createAuthenWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           state:[SecurityManager sharedInstance].state
                            type:TouchIDHandelType_Verify
                 didTouchIDBlock:block];
}

- (BOOL)state
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTouchIDHandelKey];
}

// 更新设置状态
- (void)updateTouchIdObject:(BOOL)object
{
    [[NSUserDefaults standardUserDefaults] setObject:@(object) forKey:kTouchIDHandelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 更新单例属性
    [SecurityManager sharedInstance].state = object;
}

// 开启指纹扫描
- (void)createAuthenWithPolicy:(LAPolicy )policy state:(BOOL)state type:(TouchIDHandelType)type didTouchIDBlock:(TouchIdDidResultBlock)block {
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"验证登录密码";
    // LAPolicyDeviceOwnerAuthentication
    __weak typeof(self) weakSelf = self;
    [context evaluatePolicy:policy localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"";
            if (success) { //验证成功
                message = @"通过了TouchID指纹验证";
                block(success, message);
                
                if (type == TouchIDHandelType_Setting) {
                    if (state) {
                        [self updateTouchIdObject:NO];
                    }else {
                        [self updateTouchIdObject:YES];
                    }
                }
            } else { // 验证失败
                if (type == TouchIDHandelType_Setting) {
                    if (state) {
                        [self updateTouchIdObject:YES];
                    }else {
                        [self updateTouchIdObject:NO];
                    }
                }

                LAError errorCode = error.code;
                BOOL inputPassword = NO;
                switch (errorCode) {
                    case LAErrorAuthenticationFailed: {
                        // -1
                        message = @"连续三次指纹识别错误";
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        // -2
                        message = @"用户取消验证Touch ID";
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        // -3
                        inputPassword = YES;
                        message = @"用户选择输入密码";
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        message = @"取消授权，如其他应用切入";
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        // -5
                        message = @"设备系统未设置密码";
                    }
                        break;
                        
                    case LAErrorTouchIDNotAvailable: {
                        // -6
                        message = @"此设备不支持 Touch ID";
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                        // -7
                        message = @"用户未录入指纹";
                    }
                        break;
                    case LAErrorTouchIDLockout: {
                        // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        if (iOS9) {
                            if (@available(iOS 9.0, *)) {
                                [weakSelf createAuthenWithPolicy:LAPolicyDeviceOwnerAuthentication state:[SecurityManager sharedInstance].state type:type didTouchIDBlock:block];
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        message = @"Touch ID被锁，需要用户输入密码解锁";
                    }
                        break;
                        
                    case kLAErrorAppCancel: {
                        // -9 如突然来了电话，电话应用进入前台，APP被挂起啦
                        message = @"用户不能控制情况下APP被挂起";
                    }
                        break;
                        
                    case kLAErrorInvalidContext: {
                        // -10
                        message = @"Touch ID 失效";
                    }
                        break;
                        
                    default:
                        message = @"此设备不支持 Touch ID";
                        break;
                }
                block(success, message);
            }
        });
    }];
}


@end
