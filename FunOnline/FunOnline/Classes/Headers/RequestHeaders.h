//
//  RequestHeaders.h
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#ifndef RequestHeaders_h
#define RequestHeaders_h

#pragma mark - ***************************** 壁纸&新闻 *****************************
/// 服务端口1
static  NSString *kGlobalHost1 = @"http://service.picasso.adesk.com";
#define kFirsterUrl(url)  [NSString stringWithFormat:@"%@%@", kGlobalHost1, url]

/** 首页热门推荐 */
#define url_homeHot    kFirsterUrl(@"/v2/homepage")

/** 壁纸评论 */
#define url_comment    kFirsterUrl(@"v2/wallpaper/wallpaper")

/** 首页分类 */
#define url_classify   kFirsterUrl(@"/v1/wallpaper/category")

/** 首页最新壁纸 */
#define url_newwp      kFirsterUrl(@"/v1/wallpaper/wallpaper")

/** 新闻 */
#define url_news       @"http://api.ipadown.com/apple-news-client/news.list.php?"



#pragma mark - ***************************** 音乐 *****************************
/// 服务端口2
static  NSString *kGlobalHost2 = @"http://mobile.ximalaya.com";
#define kMusicUrl(url)  [NSString stringWithFormat:@"%@%@", kGlobalHost2, url]

/** 音乐推荐列表 */
#define url_music_Recommend    kMusicUrl(@"/mobile/discovery/v2/category/recommends")

/** 音乐分类 */
#define url_music_classify     kMusicUrl(@"/mobile/discovery/v2/category/recommends")

/** 分类详情列表 */
#define url_music_list         kMusicUrl(@"/mobile/discovery/v1/category/album")

/** 更多分类详情列表 */
#define url_more_music         @"http://180.153.255.6/mobile/discovery/v2/category/filter/albums/ts-1526870755114?"

/** 音乐播放详情 */
#define url_music_detail       kMusicUrl("/mobile/others/ca/album/track/2650009/true/1/20?")

#endif /* RequestHeaders_h */

