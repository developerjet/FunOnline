//
//  SecurityManager.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/4/2.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TouchIDHandelType_Verify,  //验证TouchID
    TouchIDHandelType_Setting, //设置TouchID
}TouchIDHandelType;


/**
 TouchID解锁(设置&验证)回调

 @param success 验证结果
 @param message 验证信息
 */
typedef void(^TouchIdDidResultBlock)(BOOL success, NSString *message);

@interface SecurityManager : NSObject

/** 单例 */
+ (instancetype)sharedInstance;

/**
 开启/关闭指纹解锁处理
 
 @param block 验证结果回调
 */
- (void)openIsTouchIDWithController:(UIViewController *)controller
                            message:(NSString *)message
                              block:(TouchIdDidResultBlock)block;

/**
 直接进行已设置的TouchID验证

 @param block 验证结果回调
 */
- (void)verifyTouchIDWithBlock:(TouchIdDidResultBlock)block;

/** 指纹验证设置状态 */
@property (nonatomic, assign) BOOL state;

@end
