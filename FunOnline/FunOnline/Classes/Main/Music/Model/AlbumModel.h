//
//	Album.m
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

#import <UIKit/UIKit.h>

@interface AlbumModel : NSObject

@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, assign) BOOL canInviteListen;
@property (nonatomic, assign) BOOL canShareAndStealListen;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * coverLarge;
@property (nonatomic, strong) NSString * coverLargePop;
@property (nonatomic, strong) NSString * coverMiddle;
@property (nonatomic, strong) NSString * coverOrigin;
@property (nonatomic, strong) NSString * coverSmall;
@property (nonatomic, strong) NSString * coverWebLarge;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * customSubTitle;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) BOOL hasNew;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * introRich;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isDraft;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) BOOL isPaid;
@property (nonatomic, assign) BOOL isRecordDesc;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, assign) NSInteger lastUptrackAt;
@property (nonatomic, strong) NSString * lastUptrackCoverPath;
@property (nonatomic, assign) NSInteger lastUptrackId;
@property (nonatomic, strong) NSString * lastUptrackTitle;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) NSInteger offlineReason;
@property (nonatomic, assign) NSInteger offlineType;
@property (nonatomic, assign) NSInteger playTimes;
@property (nonatomic, assign) NSInteger playTrackId;
@property (nonatomic, assign) NSInteger refundSupportType;
@property (nonatomic, assign) NSInteger saleScope;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, assign) NSInteger serializeStatus;
@property (nonatomic, assign) NSInteger shareSupportType;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, strong) NSString * shortIntro;
@property (nonatomic, strong) NSString * shortIntroRich;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger unReadAlbumCommentCount;
@property (nonatomic, assign) NSInteger updatedAt;
@property (nonatomic, assign) NSInteger vipFreeType;

@end
