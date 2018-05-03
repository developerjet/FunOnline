//
//  WallpaperModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WallpaperModel.h"

@implementation WallpaperModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"Id": @"id",
             @"coverTemp": @"cover_temp",
             @"picassoCover": @"picasso_cover"
             };
}

@end
