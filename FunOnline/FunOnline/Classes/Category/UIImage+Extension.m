//
//  UIImage+Extension.m
//  OnlyBother_Personal
//
//  Created by 马康旭 on 2016/11/22.
//
//

#import "UIImage+Extension.h"
//#import "SDImageCache.h"

@implementation UIImage (Extension)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this newcontext, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *)imageToMax800Image
{
    CGSize size = self.size;
    CGFloat height, width;
    if (size.height > size.width) {
        if (size.height > 800) {
            width = size.width * 800 / size.height;
            height = 800;
        }
        else {
            width = size.width;
            height = size.height;
        }
    }
    else {
        if (size.width > 800) {
            height = size.height * 800 / size.width;
            width = 800;
        }
        else {
            height = size.height;
            width = size.width;
        }
    }
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

- (UIImage *)imageToImageMaxWidthOrHeight:(CGFloat)max
{
    CGSize size = self.size;
    CGFloat height, width;
    if (size.height > size.width) {
        if (size.height > max) {
            width = size.width * max / size.height;
            height = max;
        }
        else {
            width = size.width;
            height = size.height;
        }
    }
    else {
        if (size.width > max) {
            height = size.height * max / size.width;
            width = max;
        }
        else {
            height = size.height;
            width = size.width;
        }
    }
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

- (UIImage *)imageToImageMaxHeight:(CGFloat)max
{
    CGSize size = self.size;
    CGFloat height, width;
    width = size.width * max / size.height;
    height = max;
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

- (UIImage *)imageToImageMax:(CGSize)maxSize
{
    CGSize size = self.size;
    CGFloat height, width;
    if (size.height > size.width) {
        if (size.height > maxSize.height) {
            width = size.width * maxSize.height / size.height;
            height = maxSize.height;
        }
        else {
            width = size.width;
            height = size.height;
        }
    }
    else {
        if (size.width > maxSize.width) {
            height = size.height * maxSize.width / size.width;
            width = maxSize.width;
        }
        else {
            height = size.height;
            width = size.width;
        }
    }
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

- (UIImage *)imageToMaxImage:(CGSize)maxSize
{
    CGSize size = self.size;
    CGFloat height, width;
    if (size.height > size.width) {
        if (size.height > maxSize.height) {
            width = size.width * maxSize.height / size.height;
            height = maxSize.height;
        }
        else {
            width = size.width;
            height = size.height;
        }
        
        if (width > maxSize.width) {
            width = maxSize.width;
            height = size.height * maxSize.width / size.width;
        }
    }
    else {
        if (size.width > maxSize.width) {
            height = size.height * maxSize.width / size.width;
            width = maxSize.width;
        }
        else {
            height = size.height;
            width = size.width;
        }
        
        if (height > maxSize.height) {
            width = size.width * maxSize.height / size.height;
            height = maxSize.height;
        }
    }
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

/**
 *  按照viewsize 对图片进行等比缩放
 *
 *  param viewSize
 *
 *  @return 适配的图片
 */
- (UIImage *)imageFixImageViewSize:(CGSize)viewSize
{
    CGSize imageSize = self.size;
    //缩放比例
    int width = imageSize.width;
    int height = imageSize.height;
    
    if (viewSize.width != width) {
        //适配宽度
        width = viewSize.width;
        height = imageSize.height/(float)imageSize.width*width;
    }
    if (viewSize.height>height) {
        //适配高度
        height = viewSize.height;
        width = imageSize.width/(float)imageSize.height*height;
    }
    
    UIImage *img = [UIImage imageWithImageSimple:self scaledToSize:CGSizeMake(width, height)];
    return img;
}

+ (NSArray *)getBigImageFromImage:(UIImage *)image
{
    CGSize size = image.size;
    CGFloat bigHeight, bigWidth, smallHeight, smallWidth;
    if (size.height > size.width) {
        if (size.height > 800) {
            bigWidth = size.width * 800 / size.height;
            bigHeight = 800;
        }
        else {
            bigWidth = size.width;
            bigHeight = size.height;
        }
        if (bigHeight > 100) {
            smallWidth = bigWidth * 100 / bigHeight;
            smallHeight = 100;
        }
        else {
            smallWidth = bigWidth;
            smallHeight = bigHeight;
        }
    }
    else {
        if (size.width > 800) {
            bigHeight = size.height * 800 / size.width;
            bigWidth = 800;
        }
        else {
            bigHeight = size.height;
            bigWidth = size.width;
        }
        if (bigWidth > 100) {
            smallHeight = bigHeight * 100 / bigWidth;
            smallWidth = 100;
        }
        else {
            smallHeight = bigHeight;
            smallWidth = bigWidth;
        }
    }
    UIImage *bigImage = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(bigWidth, bigHeight)];
    UIImage *smallImage = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(smallWidth, smallHeight)];
    
    return @[bigImage,smallImage];
}

- (id)diskImageDataBySearchingAllPathsForKey:(id)key{return nil;}

+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


+ (UIImage *)imageFitScreen:(UIImage *)image withSize:(CGSize)size
{
    UIImage *resultsImg;
    
    CGSize origImgSize = [image size];
    
    CGRect newRect = CGRectZero;
    newRect.size = size;
    
    float widthProportion = newRect.size.width / origImgSize.width;
    float heightProportion = newRect.size.height / origImgSize.height;
    
    //确定缩放倍数
    float ratio;
    CGRect rect;
    
    if (widthProportion >=1 && heightProportion >=1) {
        ratio = MIN(widthProportion, heightProportion);
        rect.size.width = ratio * origImgSize.width;
        rect.size.height = ratio * origImgSize.height;
    }
    else if (widthProportion <=1 && heightProportion <=1) {
        ratio = MAX(widthProportion, heightProportion);
        rect.size.width = ratio * origImgSize.width;
        rect.size.height = ratio * origImgSize.height;
    }
    else if (widthProportion >1 && heightProportion <1) {
        if (widthProportion < -heightProportion) {
            ratio = widthProportion;
            rect.size.width = ratio * origImgSize.width;
            rect.size.height = ratio * origImgSize.height;
        }
        else {
            ratio = -heightProportion;
            rect.size.width = ratio * origImgSize.width;
            rect.size.height = ratio * origImgSize.height;
        }
    }
    else if (widthProportion <1 && heightProportion >1) {
        if (heightProportion < -widthProportion) {
            ratio = heightProportion;
            rect.size.width = ratio * origImgSize.width;
            rect.size.height = ratio * origImgSize.height;
        }
        else {
            ratio = -widthProportion;
            rect.size.width = ratio * origImgSize.width;
            rect.size.height = ratio * origImgSize.height;
        }
    }
    else {
        ratio = MIN(newRect.size.width / origImgSize.width, newRect.size.height / origImgSize.height);
        rect.size.width = ratio * origImgSize.width;
        rect.size.height = ratio * origImgSize.height;
    }
    
    //    rect.origin.x = (newRect.size.width - rect.size.width) / 2.0;
    rect.origin.x = 0;
    rect.origin.y = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    
    [image drawInRect:rect];
    
    resultsImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultsImg;
}

+(UIImage *)imageWithColor:(UIColor *)color{
    
   return  [self imageWithColor:color andSize:CGSizeMake(2, 2)];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

///保持图片不旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


@end
