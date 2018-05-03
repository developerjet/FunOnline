//
//  WallpaperCollectionCell.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallpaperModel.h"

@class WallPaperCollectionCell;

@protocol WallPaperCellDelegate<NSObject>
@optional
- (void)cell:(WallPaperCollectionCell *)cell DidSelectIndexAtItem:(WallpaperModel *)item;
@end

@interface WallPaperCollectionCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, strong) WallpaperModel *model;

@property (nonatomic, weak) id<WallPaperCellDelegate> delegate;

@end
