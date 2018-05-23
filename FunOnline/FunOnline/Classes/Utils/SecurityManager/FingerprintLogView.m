//
//  FingerprintLogView.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/4/2.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FingerprintLogView.h"

@interface FingerprintLogView()

@property (nonatomic, strong) UIImageView *logImageView;
@property (nonatomic, strong) UIButton    *fingerButton;
@property (nonatomic, strong) UILabel     *placeholdLabel;

@end

@implementation FingerprintLogView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.alpha = 0.5;
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self configSubview];
    }
    return self;
}

- (void)configSubview
{
    self.logImageView = [[UIImageView alloc] init];
    self.logImageView.image = [UIImage imageNamed:@"icon_app_placehold"];
    [self addSubview:self.logImageView];

    self.fingerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fingerButton setImage:[UIImage imageNamed:@"mine_exist_logo"] forState:UIControlStateNormal];
    [self.fingerButton addTarget:self action:@selector(starFingerprint) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fingerButton];

    self.placeholdLabel = [[UILabel alloc] init];
    self.placeholdLabel.text = @"点击进行指纹解锁";
    self.placeholdLabel.font = [UIFont systemFontOfSize:13];
    self.placeholdLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.placeholdLabel];
}

- (void)addAdjustLayout {
    
    CGFloat s_w = self.frame.size.width;
    CGFloat s_h = self.frame.size.height;
    
    self.logImageView.frame = CGRectMake(0, 0, 90, 90);
    self.logImageView.center = CGPointMake(s_w * 0.5, 100);
    
    self.fingerButton.frame = CGRectMake(0, 0, 60, 60);
    self.fingerButton.center = CGPointMake(s_w * 0.5, s_h * 0.5);
    
    CGFloat labelW = 150;
    CGFloat labelY = CGRectGetMaxY(self.fingerButton.frame) + 5;
    self.placeholdLabel.frame = CGRectMake((s_w - labelW)/2, labelY, labelW, 21);
}

#pragma mark - Action

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        [self starFingerprint];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        [self removeFromSuperview];
    }];
}

- (void)starFingerprint {
    
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SecurityManager sharedInstance] verifyTouchIDWithBlock:^(BOOL success, NSString *message) {
            if (success) {
                [weakSelf dismiss];
            }else {
                [XDProgressHUD showHUDWithLongText:message hideDelay:1.0];
            }
        }];
    });
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addAdjustLayout];
}

@end
