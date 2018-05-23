//
//  CommentViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CommentViewController.h"
#import "CMSeactionMenuView.h"
#import "CommentGroupCell.h"
#import "SDPhotoBrowser.h"
#import "WallPaperModel.h"
#import "Comment.h"

static NSString *const kCommentCellIdentifier    = @"kCommentCellIdentifier";
static NSString *const kCommentSectionIdentifier = @"kCommentSectionIdentifier";

typedef enum {
    ImageActionAsSavePhoto = 0,
    ImageActionAsStarInfo
}ImageActionType;

@interface CommentViewController ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIImageView *screenImageView;
@property (nonatomic, strong) NSMutableArray *commentGroup;
@property (nonatomic, strong) NSMutableArray *sectionGroup;
@property (nonatomic, strong) NSMutableArray *browserImages;

/** 收藏按钮 */
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation CommentViewController

#pragma mark - Lazys

- (NSMutableArray *)commentGroup
{
    if (!_commentGroup) {
        
        _commentGroup = [[NSMutableArray alloc] init];
    }
    return _commentGroup;
}

- (NSMutableArray *)sectionGroup
{
    if (!_sectionGroup) {
        
        _sectionGroup = [NSMutableArray arrayWithCapacity:0];
    }
    return _sectionGroup;
}

- (NSMutableArray *)browserImages
{
    if (!_browserImages) {
        
        _browserImages = [NSMutableArray arrayWithCapacity:0];
    }
    return _browserImages;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = [self titleString];
    
    [self initSubview];
    [self loadComment];
}

- (NSString *)titleString {
    NSString *title = @"评论";
    
    if (self.model.desc.length) {
        title = self.model.desc;
    }
    if (self.model.tag.count) {
        title = [self.model.tag firstObject];
    }
    return title;
}

- (void)initSubview
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setImage:[UIImage imageNamed:@"favorite_normal"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"favorite_select"] forState:UIControlStateSelected];
    [startButton addTarget:self action:@selector(starEvent:) forControlEvents:UIControlEventTouchUpInside];
    [startButton sizeToFit];
    UIView *customView = [[UIView alloc] initWithFrame:startButton.bounds];
    [customView addSubview:startButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.startButton = startButton;
    
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    self.screenImageView = [[UIImageView alloc] initWithFrame:tableViewHeader.bounds];
    [self.screenImageView downloadImage:self.model.img placeholder:@"icon_default_image"];
    [tableViewHeader addSubview:self.screenImageView];
    self.tableView.tableHeaderView = tableViewHeader;
    
    self.screenImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showScreen)];
    [self.screenImageView addGestureRecognizer:tap];
    
    [self.browserImages addObject:self.model.img]; //添加图片url
    [self starVetify:self.model]; // 验证收藏
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[CommentGroupCell class] forCellReuseIdentifier:kCommentCellIdentifier];
    [self.tableView registerClass:[CMSeactionMenuView class] forHeaderFooterViewReuseIdentifier:kCommentSectionIdentifier];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
    self.tableView.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadComment];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)showScreen
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = 0;
    photoBrowser.imageCount = self.browserImages.count;
    photoBrowser.sourceImagesContainerView = [UIApplication sharedApplication].keyWindow;
    [photoBrowser show];
}

- (void)starEvent:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        self.model.isStar = YES;
        [[CacheManager sharedManager] startNewPictureWithModel:self.model];
        [XDProgressHUD showHUDWithText:@"收藏成功" hideDelay:1.0];
    }else {
        self.model.isStar = NO;
        [[CacheManager sharedManager] unstartPictureWithModel:self.model];
        [XDProgressHUD showHUDWithText:@"取消收藏" hideDelay:1.0];
    }
    
    // 发出收藏列表刷新通知
    [NC postNotificationName:NC_Reload_Picture object:nil];
    
}

- (void)starVetify:(WallPaperModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[CacheManager sharedManager] isStartPictureWithModel:model]) {
            self.startButton.selected = YES;
        }else {
            self.startButton.selected = NO;
        }
    });
}

- (void)loadComment
{
    NSString *urlStr = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v2/wallpaper/wallpaper/%@/comment",self.model.Id];
    
    [[RequestManager manager] GET:urlStr parameters:nil success:^(id  _Nullable responseObj) {
        [self endRefreshing];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"success"]) {
            [self clearLastObjects];
            
            NSArray *hotObjects = [Comment mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"hot"]]; //热评
            NSArray *newObjects = [Comment mj_objectArrayWithKeyValuesArray:responseObj[@"res"][@"comment"]];
            
            if (hotObjects.count) {
                [self.commentGroup addObject:hotObjects];
                [self.sectionGroup addObject:@"最热"];
            }if (newObjects.count) {
                [self.commentGroup addObject:newObjects];
                [self.sectionGroup addObject:@"最新"];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
    
        [self endRefreshing];
    }];
}


- (void)clearLastObjects
{
    if (self.commentGroup.count || self.sectionGroup.count) {
        [self.commentGroup removeAllObjects];
        [self.sectionGroup removeAllObjects];
    }
}

#pragma mark - table for data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.commentGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *datas = self.commentGroup[section];
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
    if (self.commentGroup.count > indexPath.section) {
        NSArray *data = self.commentGroup[indexPath.section];
        if (data.count > indexPath.row) {
            cell.comment = self.commentGroup[indexPath.section][indexPath.row];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CMSeactionMenuView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentSectionIdentifier];
    if (self.commentGroup.count > section) {
        sectionHeader.title = self.sectionGroup[section];
    }
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *model = self.commentGroup[indexPath.section][indexPath.row];
    return model.cellHeight;
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.browserImages[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

#pragma mark - <DZNEmptyDataSetDataSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"暂无评论哟~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor colorThemeColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

@end
