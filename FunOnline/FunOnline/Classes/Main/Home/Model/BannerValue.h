//
//  BannerValues.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerValue : NSObject

@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) BOOL isfeed;
@property (nonatomic, copy) NSString *ename;
@property (nonatomic, copy) NSString *atime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *value_id;
@property (nonatomic, assign) NSUInteger sn;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, copy) NSString *lcover;
@property (nonatomic, copy) NSString *favs;

@end
