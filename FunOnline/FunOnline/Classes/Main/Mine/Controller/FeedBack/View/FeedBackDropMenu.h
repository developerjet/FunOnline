//
//  FeedBackDropMenu.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedBackDropMenu;

@protocol FeedBackDropMenuDelegate<NSObject>

@optional
/** 获取已输入手机号码 */
- (void)menu:(FeedBackDropMenu *)menu DidTextFieldEditing:(NSString *)text;
/** 获取已输入反馈信息 */
- (void)menu:(FeedBackDropMenu *)menu DidTextViewEditing:(NSString *)text;

@end

@interface FeedBackDropMenu : UIView

@property (nonatomic, weak) id<FeedBackDropMenuDelegate> delegate;

@end
