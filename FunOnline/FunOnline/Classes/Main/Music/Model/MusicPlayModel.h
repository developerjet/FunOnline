//
//  MusicListModel.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicPlayModel : NSObject

@property (nonatomic, strong) NSString * albumCoverUrl290;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, strong) NSString * coverPath;
@property (nonatomic, strong) NSString * coverLarge;
@property (nonatomic, strong) NSString * coverSmall;
@property (nonatomic, strong) NSString * coverMiddle;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) BOOL isDraft;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, assign) BOOL isPaid;
@property (nonatomic, assign) BOOL isVipFree;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, assign) NSInteger playtimes;
@property (nonatomic, assign) NSInteger priceTypeId;
@property (nonatomic, strong) NSString * provider;
@property (nonatomic, assign) NSInteger refundSupportType;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, strong) NSString * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIImage * musicIcon;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString * trackTitle;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * playUrl64;
@property (nonatomic, strong) NSString * playUrl32;
@property (nonatomic, strong) NSString * playPathHq;
@property (nonatomic, strong) NSString * playPathAacv164;
@property (nonatomic, strong) NSString * playPathAacv224;

@end
