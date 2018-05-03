//
//  NewsModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *litpic;
@property (nonatomic, copy) NSString *writer;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isStar;

@end
