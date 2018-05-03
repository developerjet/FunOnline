//
//  HasNavViewController.h
//  BotherSellerOC
//
//  Created by CoderTan on 2017/4/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kSpacing = 10;

@interface HasNavViewController : UIViewController<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
