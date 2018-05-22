//
//  MusicClassHeaderView.h
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicClassModel.h"

@class MusicClassHeaderView;
@protocol MusicClassHeaderDelegate<NSObject>
@optional
- (void)header:(MusicClassHeaderView *)header DidSelectClassModel:(MusicClassModel *)model;

@end

@interface MusicClassHeaderView : UITableViewHeaderFooterView

/** 分割线条 */
@property (nonatomic, strong) UIView *lineView;
/** 分类名称 */
@property (nonatomic, strong) UILabel *classLabel;
/** 更多分类列表 */
@property (nonatomic, strong) UIButton *moreButton;
/** 指示箭头 */
@property (nonatomic, strong) UIImageView *arrowView;
/** 分类模型数据 */
@property (nonatomic, strong) MusicClassModel *model;
/** 代理设置 */
@property (nonatomic, weak) id<MusicClassHeaderDelegate> delegate;

@end
