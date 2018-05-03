//
//  MusicClassHeaderView.h
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicClassHeaderView : UITableViewHeaderFooterView

/** 分类名称 */
@property (nonatomic, strong) UILabel *classLabel;
/** 指示箭头 */
@property (nonatomic, strong) UIImageView *arrowView;
/** 分割线条 */
@property (nonatomic, strong) UIView *lineView;

@end
