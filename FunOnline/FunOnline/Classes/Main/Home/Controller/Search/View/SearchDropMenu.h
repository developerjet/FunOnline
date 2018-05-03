//
//  SearchDropMenu.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidCleanFinishedBlock)(void);

@interface SearchDropMenu : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic,   copy) NSString *title;
/** 清除历史搜索记录 */
@property (nonatomic,  copy) DidCleanFinishedBlock didCleanBlock;

@end
