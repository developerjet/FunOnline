//
//  Comment.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "Comment.h"
#import "UIView+TJExtension.h"

static CGFloat labelH = 21;
static CGFloat space  = 15, margin = 10, starWidth = 60;

@implementation Comment

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id": @"id"};
}

- (CGRect)avatarFrame {
    
    return CGRectMake(space, margin, 40, 40);
}

- (CGRect)usernameFrame {
    
    CGFloat usernameY = margin;
    CGFloat usernameX = CGRectGetMaxX(self.avatarFrame) + margin;
    CGFloat usernameW = SCREEN_WIDTH - usernameX - space;
    return CGRectMake(usernameX, usernameY, usernameW, labelH);
}

- (CGRect)timeFrame {
    
    CGFloat timeY = CGRectGetMaxY(self.usernameFrame) + 2;
    CGFloat timeX = self.usernameFrame.origin.x;
    CGFloat timeW = self.usernameFrame.size.width;
    return CGRectMake(timeX, timeY, timeW, labelH);
}

- (CGRect)connectFrame {
    
    CGFloat connectH = 0;
    CGFloat connectX = self.timeFrame.origin.x;
    CGFloat connectY = CGRectGetMaxY(self.timeFrame) + margin;
    CGFloat connectW = SCREEN_WIDTH - (CGRectGetMaxX(self.avatarFrame) + margin) - starWidth - margin;
    
    if (!self.content || !self.content.length) {
        connectH = 0;
    }else {
        connectH = [self commentSizeWithText:self.content].height;
    }
    return CGRectMake(connectX, connectY, connectW, connectH);
}

- (CGRect)statFrame {
    
    CGFloat starH = 18;
    CGFloat starX = SCREEN_WIDTH - starWidth - 5;
    CGFloat starY = CGRectGetMaxY(self.connectFrame) - starH;
    return CGRectMake(starX, starY, starWidth, starH);
}

- (CGSize)commentSizeWithText:(NSString *)text {
    
    CGFloat width = SCREEN_WIDTH - (CGRectGetMaxX(self.avatarFrame) + margin) - starWidth - margin;
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}
                                     context:nil].size;
    return size;
}


- (CGFloat)cellHeight {
    
    return CGRectGetMaxY(self.connectFrame) + margin;
}

@end
