//
//  BannerModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerValue.h"

@interface BannerModel : NSObject

@property (nonatomic, assign) NSInteger atime;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSArray * market;
@property (nonatomic, assign) NSInteger module;
@property (nonatomic, strong) NSString * kNewImage;
@property (nonatomic, strong) NSString * knewThumb;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSString * longTitle;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * trackId;
@property (nonatomic, assign) NSInteger offtm;
@property (nonatomic, strong) NSObject * oid;
@property (nonatomic, assign) NSInteger ontm;
@property (nonatomic, strong) NSString * reco;
@property (nonatomic, strong) NSString * target;
@property (nonatomic, strong) NSString * thumb;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString *Id;

@property (nonatomic, strong) NSArray *value;
@property (nonatomic, strong) BannerValue *valueModel;

@end
