//
//  MineTableViewCell.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, strong) MineModel *model;
@property (nonatomic, assign) BOOL hideArrow;
@property (nonatomic, assign) BOOL hideLine;

@end
