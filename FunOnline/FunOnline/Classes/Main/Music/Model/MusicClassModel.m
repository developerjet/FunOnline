//
//  MusicBaseModel.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassModel.h"

@implementation MusicClassModel

+ (void)load {
    //驼峰转下划线
    [self mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
        
        return [propertyName mj_underlineFromCamel];
    }];
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[MusicPlayModel class]};
}

@end
