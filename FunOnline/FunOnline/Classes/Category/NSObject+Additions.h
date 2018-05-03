//
//  NSObject+Additions.h
//  Link
//
//  Created by apple on 14-6-3.
//  Copyright (c) 2014年 51sole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (BOOL)isEmpty;

+ (BOOL)isEmpty1:(id)object;

+ (NSString*)NullToEmpty:(NSString*)string;

+ (NSString *)removeBlank:(NSString *)str;

/**
 *  截取包含自带表情字符串 的最大索引范围内的字符串
 *
 *  @param string 目标字符串
 *  @param index  期望的最大下标索引
 *
 *  @return 实际截取的完整字符串，可能实际截取的长度比预计的短（index刚好在表情的中间，表情的字符长度是2）
 */
+ (NSString*)getSubIndexWithString:(NSString *)string maxIndex:(NSInteger)index;

@end
