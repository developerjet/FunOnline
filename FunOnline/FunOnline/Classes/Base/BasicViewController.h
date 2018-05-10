//
//  ViewController.h
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "CustomeViewLayout.h"

static int maxColumn   = 2;  //默认列数
static CGFloat spacing = 10; //常用间距

@interface BasicViewController : UIViewController
<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIActionSheetDelegate,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CustomViewLayoutDelegate>


/**
 *  基类的table
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  基类的UICollectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  请求页码
 */
@property (nonatomic, assign) NSInteger page;

/**
 *  暂停列表上下拉刷新
 */
- (void)endRefreshing;

/**
 *  再次头部刷新
 */
- (void)recoverRefresh;

/**
 * 上下拉刷新处理(子类可重写)
 *
 * @param page 页码
 */
- (void)showRefreshing:(NSInteger)page;

@end

