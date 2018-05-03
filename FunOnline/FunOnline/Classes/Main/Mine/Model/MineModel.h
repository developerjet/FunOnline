//
//  MineModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;

/************************* 构造方法 *************************/

+ (instancetype)initWithTitle:(NSString *)title image:(NSString *)image;

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image;

@end
