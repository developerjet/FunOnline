//
//  FoodsSearchBar.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/16.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MClassSearchBar.h"

@implementation MClassSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.translucent = YES;
        self.placeholder = @"请输入关键词";
        self.searchBarStyle = UISearchBarStyleDefault;
        self.layer.cornerRadius  = self.layer.frame.size.height * 0.5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
