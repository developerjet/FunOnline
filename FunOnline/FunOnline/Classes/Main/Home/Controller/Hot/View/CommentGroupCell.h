//
//  CommentGroupCell.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentGroupCell : UITableViewCell

/** 用户评论数据模型 */
@property (nonatomic, strong) Comment *comment;

@end
