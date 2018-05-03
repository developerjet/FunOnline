//
//  NSObject+Additions.m
//  Link
//
//  Created by apple on 14-6-3.
//  Copyright (c) 2014年 51sole. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

- (BOOL)isEmpty
{
    BOOL isEmpty = YES;
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(self && self != nil)
    {
        if([self isKindOfClass:[NSString class]])
        {
            if (self == nil || self == NULL) {
                return YES;
            }
            if(![@"" isEqualToString:[(NSString *)self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
            {
                isEmpty = NO;
            }
        }
        else if([self isKindOfClass:[NSArray class]])
        {
            if([(NSArray *)self count] > 0)
            {
                isEmpty = NO;
            }
        }
        else if([self isKindOfClass:[NSDictionary class]])
        {
            if([[(NSDictionary *)self allKeys] count] > 0)
            {
                isEmpty = NO;
            }
        }
        else isEmpty = NO;
    }
    return isEmpty;
}

+ (BOOL)isEmpty1:(id)object
{
    BOOL isEmpty = YES;
    
    if ([self isKindOfClass:[NSNull class]] || object == nil) {
        return YES;
    }
    
    if ([object isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if(object && object!=nil)
    {
        if([object isKindOfClass:[NSString class]])
        {
            if(![@"" isEqualToString:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
            {
                isEmpty = NO;
            }
        }
        else if([object isKindOfClass:[NSArray class]])
        {
            if([object count]>0)
            {
                isEmpty = NO;
            }
        }
        else if([object isKindOfClass:[NSDictionary class]])
        {
            if([[object allKeys] count]>0)
            {
                isEmpty = NO;
            }
        }
        else isEmpty = NO;
    }
    
    return isEmpty;
}

+ (NSString *)NullToEmpty:(NSString *)string
{
    if ([NSObject isEmpty1:string]) {
        return @"";
    }else
        return [NSString stringWithFormat:@"%@",string];
}

+ (NSString *)removeBlank:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}


+ (NSString*)getSubIndexWithString:(NSString *)string maxIndex:(NSInteger)index

{
    if ([NSObject isEmpty1:string] || index<0 || index>string.length) {
        return string;
    }
    __block NSInteger subIndex = index;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                subIndex = enclosingRange.location+enclosingRange.length;
                                if (enclosingRange.location+enclosingRange.length>=index) {
                                    //达到目标索引值 终止检索
                                    *stop = YES;
                                }
                            }];
    return [string substringToIndex:subIndex];
    
}



@end
