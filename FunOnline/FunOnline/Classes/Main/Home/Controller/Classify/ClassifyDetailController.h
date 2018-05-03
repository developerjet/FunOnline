//
//  ClassifyDetailController.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/8.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BasicViewController.h"

@interface ClassifyDetailController : BasicViewController
/// 分类ID
@property (nonatomic, strong) NSString *categoryID;
/// 标题
@property (nonatomic, strong) NSString *titleString;

@end
