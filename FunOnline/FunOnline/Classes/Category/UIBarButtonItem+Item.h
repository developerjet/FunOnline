//
//  UIButton+Item.h
//  TJBudeJie
//
//  Created by TJ on 16/5/29.
//  Copyright © 2016年 TJCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

/** 高亮状态 */
+ (instancetype)itemWithImage:(NSString *)img highlightImg:(NSString *)highlightImg target:(id)target action:(SEL)action;

/** 选中状态 */
+ (instancetype)itemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

/** 高亮状态+Title  */
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image hightImage:(UIImage *)hightImage target:(id)target action:(SEL)action;

/** 选中状态+Title */
+ (instancetype)itemWithTitle:(NSString *)title Image:(UIImage *)image selectImage:(UIImage *)selectImage target:(id)target action:(SEL)action;

@end
