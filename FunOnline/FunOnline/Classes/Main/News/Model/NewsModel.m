//
//  NewsModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"newsId": @"news_id"
             };
}

@end
