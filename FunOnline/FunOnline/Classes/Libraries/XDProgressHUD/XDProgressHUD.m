//
//  XDProgressHUD.m
//  OnlyBrother_ Seller
//
//  Created by CODER_TJ on 16/10/23.
//  Copyright © 2016年 CODER_TJ. All rights reserved.
//

#import "XDProgressHUD.h"
#import "MBProgressHUD.h"
#define kCurrentKeyWindow  [UIApplication sharedApplication].keyWindow
#define HUD_TAG  101010

@implementation XDProgressHUD

+ (void)showHUDWithText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.tag = HUD_TAG;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];//文字和菊花的颜色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithIndeterminateAndText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:kCurrentKeyWindow animated:YES];
    hud.tag = HUD_TAG;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];//文字和菊花的颜色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithLongText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];//文字和菊花的颜色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    hud.tag = HUD_TAG;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithIndeterminate:(NSString *)text
{
    UIWindow *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:NO];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    hud.contentColor = [UIColor whiteColor];//文字和菊花的颜色
    hud.tag = HUD_TAG;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showGIFWithtext:(NSString *)text
{
    UIWindow *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    
    // 自定义帧动画
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_fly_1"]];
    NSMutableArray *animationImages = [NSMutableArray new];
    for (NSInteger i = 9; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%ld", i]];
        [animationImages addObject:image];
    }
    [customView setAnimationImages:animationImages];
    [customView setAnimationDuration:1.5];
    [customView setAnimationRepeatCount:0];
    [customView startAnimating];
    
    hud = [MBProgressHUD showHUDAddedTo:window animated:NO];
    hud.tag = HUD_TAG;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor blackColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    // 设置此属性才可更改颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideHUD {
    // 放在主线程(解决内存警告)
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIWindow *window = kCurrentKeyWindow;
        MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
        if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
            [hud removeFromSuperview];
            hud = nil;
        }
    }];
}

- (UIWindow *)window {
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
