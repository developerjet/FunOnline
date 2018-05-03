//
//  MusicClassifyCell.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicClassModel.h"

@interface MusicClassifyCell : UITableViewCell

@property (nonatomic, strong) MusicClassModel *model;
@property (nonatomic, copy) NSString *imageName;

@end
