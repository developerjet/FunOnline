//
//  UIImage+Extension.h
//  OnlyBother_Personal
//
//  Created by 马康旭 on 2016/11/22.
//
//

#import <UIKit/UIKit.h>
#import "MusicPlayModel.h"

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

- (UIImage *)imageToMax800Image;
- (UIImage *)imageToMaxImage:(CGSize)maxSize;
- (UIImage *)imageToImageMaxHeight:(CGFloat)max;
+ (NSArray *)getBigImageFromImage:(UIImage *)image;
- (UIImage *)imageFixImageViewSize:(CGSize)viewSize;
/// 修改image的大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)imageToImageMaxWidthOrHeight:(CGFloat)max;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)imageFitScreen:(UIImage *)image withSize:(CGSize)size;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/// 保持图片不旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;

@end
