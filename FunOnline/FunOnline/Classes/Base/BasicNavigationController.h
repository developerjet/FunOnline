//
//  BasicNavigationController.h
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicNavigationController : UINavigationController

/**
 全屏滑动返回手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end
