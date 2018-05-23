//
//  WallpaperModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallPaperModel : NSObject

@property (nonatomic, assign) NSInteger atime;
@property (nonatomic, strong) NSArray * cid;
@property (nonatomic, assign) BOOL cr;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger favs;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger ncos;
@property (nonatomic, strong) NSString * preview;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, strong) NSString * rule;
@property (nonatomic, strong) NSString * ruleNew;
@property (nonatomic, strong) NSString * sourceType;
@property (nonatomic, strong) NSString * store;
@property (nonatomic, strong) NSArray * tag;
@property (nonatomic, strong) NSString * thumb;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSArray * url;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, strong) NSString * wp;
@property (nonatomic, assign) BOOL xr;
@property (nonatomic, assign) BOOL isStar;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ename;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * rname;
@property (nonatomic, copy) NSString * icover;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy) NSString * coverTemp;
@property (nonatomic, copy) NSString * picassoCover;

@end
