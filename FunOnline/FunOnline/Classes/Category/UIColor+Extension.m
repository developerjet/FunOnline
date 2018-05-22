//
//  UIColor+Extension.m
//  OnlyBother_Personal
//
//  Created by 马康旭 on 2016/11/22.
//
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


+ (UIColor *)colorWithHexString:(NSString *)colorStr {
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor *)colorWithRandom{
    
    CGFloat red = arc4random()%256/255.0;
    CGFloat green = arc4random()%256/255.0;
    CGFloat blue = arc4random()%256/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+(UIColor *)colorThemeColor
{
    return [UIColor colorWithHexString:@"FF82AB"];
}

//用主题色导致色差明显
+ (UIColor *)newThemeColor
{
    return [UIColor colorWithRed:236/255.0 green:185/255.0 blue:103/255.0 alpha:1];
}

+(UIColor *)colorAssistColor{
    
    return [UIColor colorWithRed:242/255.0 green:170/255.0 blue:15/255.0 alpha:1];
}

+(UIColor *)colorHudColor {
    
    return [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:0.8];
}

+(UIColor *)colorLightGrayColor{
    
    return [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
}

+(UIColor *)colorBackGroundColor{
    
    return [UIColor colorWithHexString:@"F8F8F8"];
}

+(UIColor *)colorBoardLineColor{
    
    return [UIColor colorWithHexString:@"E8E8E8"];
}

+ (UIColor *)colorWhiteColor{
    
    return [UIColor colorWithHexString:@"FFFFFF"];
}

+ (UIColor *)viewBackGroundColor {
    
    return [UIColor colorWithHexString:@"F1F1F1"];
}

+ (UIColor *)colorLoginRgisterLineColor {
    
    return [UIColor colorWithHexString:@"fed1a6"];
}


+ (UIColor *)colorDarkTextColor{
    
    return [UIColor colorWithHexString:@"323232"];
}

+ (UIColor *)colorLightTextColor{
    
    return [UIColor colorWithHexString:@"989898"];
}

+(UIColor *)colorNavigationBarColor{
    
    return [UIColor colorWithRed:235/255.0 green:176/255.0 blue:70/255.0 alpha:1];
    //return [UIColor colorWithHexString:@"fbb65e"];
}

+ (CAGradientLayer *)shadowAsInverseWithFrame:(CGRect)frame
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = frame;
    newShadow.startPoint = CGPointMake(0, .5);
    newShadow.endPoint = CGPointMake(0, 1);
    //添加渐变的颜色组合（颜色透明度的改变）
    newShadow.colors = [NSArray arrayWithObjects:
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.95] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.9] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.85] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.8] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.75] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.7] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.65] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:.6] CGColor],
                        (id)[[[UIColor colorThemeColor] colorWithAlphaComponent:0.55] CGColor],
                        nil];
//    newShadow.locations = locations;
    return newShadow;
}

/**
 修改颜色的辅助色
 */
+ (UIColor *)colorTextAssistColor{
    
    return [UIColor colorWithHexString:@"ff4200"];
}


/**
 常用按钮字体&背景颜色
 */
+ (UIColor *)totalLabelColor {
    
    return [UIColor colorWithHexString:@"fbb65e"];
}

/**
 按钮辅助色
 */
+ (UIColor *)colorButtonAssistColor{
    
    return [UIColor colorWithHexString:@"ff9850"];
}

@end
