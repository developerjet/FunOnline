//
//  UIView+TJExtension.h
//
//  Created by TJ on 16/5/20.
//  Copyright © 2016年 TJCoder. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (TJExtension)

@property (nonatomic, assign) CGSize tj_size;
@property (nonatomic, assign) CGFloat tj_width;
@property (nonatomic, assign) CGFloat tj_height;
@property (nonatomic, assign) CGFloat tj_x;
@property (nonatomic, assign) CGFloat tj_y;

@property (nonatomic, assign) CGFloat tj_centerX;
@property (nonatomic, assign) CGFloat tj_centerY;

@property (nonatomic, assign) CGFloat tj_right;
@property (nonatomic, assign) CGFloat tj_left;
@property (nonatomic, assign) CGFloat tj_bottom;

@property (nonatomic, assign) CGFloat tj_maxX;
@property (nonatomic, assign) CGFloat tj_maxY;

- (UIColor *) colorOfPoint:(CGPoint)point;

@end
