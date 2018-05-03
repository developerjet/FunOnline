//
//  BannerModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"Id": @"id",
             @"kNewImage": @"new_img",
             @"knewThumb": @"new_thumb"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"value":[BannerValue class]};
}

@end
