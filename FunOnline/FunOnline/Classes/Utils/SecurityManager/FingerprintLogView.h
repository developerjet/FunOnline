//
//  FingerprintLogView.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/4/2.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityManager.h"

@interface FingerprintLogView : UIView

- (void)show;

- (void)dismiss;

/** 进行指纹解锁验证 */
- (void)starFingerprint;

@end
