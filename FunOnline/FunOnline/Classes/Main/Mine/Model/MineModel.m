//
//  MineModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel

+ (instancetype)initWithTitle:(NSString *)title image:(NSString *)image
{
    MineModel *model = [[MineModel alloc] init];
    model.title = title;
    model.image = image;
    
    return model;
}


- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image
{
    if (self = [super init]) {
        self.title = title;
        self.image = image;
    }
    return self;
}

@end
