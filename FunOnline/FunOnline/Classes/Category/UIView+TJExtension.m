//
//  UIView+TJExtension.m
//
//  Created by TJ on 16/5/20.
//  Copyright © 2016年 TJCoder. All rights reserved.
//

#import "UIView+TJExtension.h"

@implementation UIView (TJExtension)

- (CGSize)tj_size {
    
    return self.frame.size;
}

- (void)setTj_size:(CGSize)tj_size {
    
    CGRect frame = self.frame;
    frame.size = tj_size;
    self.frame = frame;
}

- (CGFloat)tj_width {
    
    return self.frame.size.width;
}

- (CGFloat)tj_height {
    
    return self.frame.size.height;
}

- (void)setTj_width:(CGFloat)tj_width {
    
    CGRect frame = self.frame;
    frame.size.width = tj_width;
    self.frame = frame;
}

- (void)setTj_height:(CGFloat)tj_height {
    
    CGRect frame = self.frame;
    frame.size.height = tj_height;
    self.frame = frame;
}


- (CGFloat)tj_x {

    return self.frame.origin.x;
}

- (void)setTj_x:(CGFloat)tj_x {
    
    CGRect frame = self.frame;
    frame.origin.x = tj_x;
    self.frame = frame;
}

- (CGFloat)tj_y {
    
    return self.frame.origin.y;
}

- (void)setTj_y:(CGFloat)tj_y {
    
    CGRect frame = self.frame;
    frame.origin.y = tj_y;
    self.frame = frame;
}

- (CGFloat)tj_centerX {
    
    return self.center.x;
}

- (void)setTj_centerX:(CGFloat)tj_centerX {
    
    CGPoint center = self.center;
    center.x = tj_centerX;
    self.center = center;
}

- (CGFloat)tj_centerY {
    
    return self.center.y;
}

- (void)setTj_centerY:(CGFloat)tj_centerY {
    
    CGPoint center = self.center;
    center.y = tj_centerY;
    self.center = center;
}

- (CGFloat)tj_right {
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)tj_left {
    
    return CGRectGetMinX(self.frame);
}

- (CGFloat)tj_bottom {
    
    return CGRectGetMaxY(self.frame);
}

- (void)setTj_right:(CGFloat)tj_right {
    
    self.tj_x = tj_right - self.tj_width;
}


- (void)setTj_left:(CGFloat)tj_left {
    
    self.tj_x = tj_left + self.tj_width;
}

- (void)setTj_bottom:(CGFloat)tj_bottom {
    
    self.tj_y = tj_bottom - self.tj_height;
}


- (void)setTj_maxX:(CGFloat)tj_maxX {
    
    self.tj_x = tj_maxX - self.tj_width;
}

- (CGFloat)tj_maxX {
    
    return self.tj_x + self.tj_width;
}


- (void)setTj_maxY:(CGFloat)tj_maxY {
    
    self.tj_y = tj_maxY - self.tj_height;
}

- (CGFloat)tj_maxY {
    
    return self.tj_y + self.tj_height;
}

- (UIColor *)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end
