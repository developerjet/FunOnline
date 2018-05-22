//
//  MusicBaseModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassModel.h"

@implementation MusicClassModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[MusicPlayModel class]};
}

@end
