//
//  Comment.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface Comment : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *atime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) BOOL isup;

@property (nonatomic, strong) UserModel *user;

/** 头像的frame */
@property (nonatomic, assign) CGRect avatarFrame;
/** 用户名frame */
@property (nonatomic, assign) CGRect usernameFrame;
/** 时间的frame */
@property (nonatomic, assign) CGRect timeFrame;
/** 评论内容的frame */
@property (nonatomic, assign) CGRect connectFrame;
/** 点赞按钮的frame */
@property (nonatomic, assign) CGRect statFrame;


/** 列表的行高 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
