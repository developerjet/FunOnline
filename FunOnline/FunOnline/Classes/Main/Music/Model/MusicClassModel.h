//
//  MusicBaseModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicPlayModel.h"

@interface MusicClassModel : NSObject

@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *calcDimension;
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *keywordName;
@property (nonatomic, assign) NSInteger keywordId;
@property (nonatomic, assign) NSInteger moduleType;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSArray *list;

@end
