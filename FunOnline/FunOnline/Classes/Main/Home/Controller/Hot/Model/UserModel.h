//
//  UserModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *viptime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) NSInteger follower;
@property (nonatomic, assign) NSInteger following;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) BOOL isvip;

@end
