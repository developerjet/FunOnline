//
//  IBWaterWaveView.m
//  JiePos
//
//  Created by iBlocker on 2017/8/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBWaterWaveView.h"

@interface IBWaterWaveView ()
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *shapeLayer1;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;
@property (nonatomic, strong) CAGradientLayer *gradientLayer1;
@property (nonatomic, strong) CAGradientLayer *gradientLayer2;
@end
@implementation IBWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    self = [super initWithFrame:frame];
    if (self) {
        _startColor = startColor;
        _endColor = endColor;
        //self.backgroundColor = IBHexColorA(0xedf0f4, 0.1);
        self.backgroundColor = IBHexColorA(0xffffff, 1.0);
        self.layer.masksToBounds = YES;
        
        [self ConfigParams];
        [self startWave];
    }
    return self;
}

#pragma mark 配置参数
- (void)ConfigParams {
    if (!_waveWidth) {
        _waveWidth = self.frame.size.width;
    }
    if (!_waveHeight) {
        _waveHeight = 10;
    }
    //  背景色
    if (!_waveColor) {
        _waveColor = [UIColor whiteColor];
    }
    
    if (!_waveSpeed) {
        _waveSpeed = 2.5f;
    }
    if (!_waveOffsetX) {
        _waveOffsetX = 0;
    }
    if (!_wavePointY) {
        _wavePointY = 208;
    }
    if (!_waveAmplitude) {
        _waveAmplitude = 10;
    }
    if (!_waveCycle) {
        _waveCycle =  1.29 * M_PI / _waveWidth;
    }
}

#pragma mark 加载layer ，绑定runloop 帧刷新
- (void)startWave {
    [self.layer addSublayer:self.shapeLayer1];
    [self.layer addSublayer:self.shapeLayer2];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - 帧动画
- (void)getCurrentWave {
    _waveOffsetX += _waveSpeed;
    
    [self changeFirstWaveLayerPath];
    [self changeSecondWaveLayerPath];
    
    [self.layer addSublayer:self.gradientLayer1];
    self.gradientLayer1.mask = _shapeLayer1;
    
    [self.layer addSublayer:self.gradientLayer2];
    self.gradientLayer2.mask = _shapeLayer2;
}

#pragma mark - 路径
- (void)changeFirstWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waveWidth; x ++) {
        y = _waveAmplitude * 1.6 * sin((250 / _waveWidth) * (x * M_PI / 180) - _waveOffsetX * M_PI / 270) + _wavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    _shapeLayer1.path = path;
    CGPathRelease(path);
    
    if (self.waveChangeBlock) {
        self.waveChangeBlock(y);
    }
}

- (void)changeSecondWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waveWidth; x ++) {
        
        y = _waveAmplitude * 1.6 * sin((250 / _waveWidth) * (x * M_PI / 180) - _waveOffsetX * M_PI / 180) + _wavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    _shapeLayer2.path = path;
    
    CGPathRelease(path);
}

#pragma mark - Getter
- (CAGradientLayer *)gradientLayer1 {
    if (!_gradientLayer1) {
        _gradientLayer1 = [CAGradientLayer layer];
        _gradientLayer1.frame = self.bounds;
        _gradientLayer1.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
        _gradientLayer1.locations = @[@0, @1.0];
        _gradientLayer1.startPoint = CGPointMake(0, 0);
        _gradientLayer1.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer1;
}

- (CAGradientLayer *)gradientLayer2 {
    if (!_gradientLayer2) {
        _gradientLayer2 = [CAGradientLayer layer];
        _gradientLayer2.frame = self.bounds;
        _gradientLayer2.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
        _gradientLayer2.locations = @[@0, @1.0];
        _gradientLayer2.startPoint = CGPointMake(0, 0);
        _gradientLayer2.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer2;
}


- (CAShapeLayer *)shapeLayer1 {
    if (!_shapeLayer1) {
        _shapeLayer1 = [CAShapeLayer layer];
    }
    return _shapeLayer1;
}

- (CAShapeLayer *)shapeLayer2 {
    if (!_shapeLayer2) {
        _shapeLayer2 = [CAShapeLayer layer];
    }
    return _shapeLayer2;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
}
@end
