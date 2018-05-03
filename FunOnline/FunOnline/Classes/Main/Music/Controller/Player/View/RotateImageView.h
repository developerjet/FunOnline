//
//  RotateImageView.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotateImageView : UIImageView

/** 开始旋转 */
- (void)startRotating;
/** 停止旋转 */
- (void)stopRotating;
/** 恢复旋转 */
- (void)resumeRotate;

@end
