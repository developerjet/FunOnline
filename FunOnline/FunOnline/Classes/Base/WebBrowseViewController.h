//
//  WebbrowerViewController.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BasicViewController.h"

@class NewsModel;
@interface WebBrowseViewController : BasicViewController
/// loading url
@property (nonatomic, copy) NSString *urlString;
/// loaded title
@property (nonatomic, copy) NSString *titleString;
/// news model
@property (nonatomic, strong) NewsModel *model;

@end
