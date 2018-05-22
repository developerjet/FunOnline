//
//  MusicRecommendController.m
//  FunOnline
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicHotViewController.h"
#import "MusicMoreListController.h"
#import "MusicPlayListController.h"
#import "FLCycleCarouselView.h"
#import "MusicClassHeaderView.h"
#import "MusicMoreListCell.h"
#import "MusicClassModel.h"
#import "BannerModel.h"

static NSString *const kMusicClassesCellIdentifier   = @"kMusicClassesCellIdentifier";
static NSString *const kMusicClassesHeaderIdentifier = @"kMusicClassesHeaderIdentifier";

@interface MusicHotViewController ()<InfiniteCarouselDelegate, MusicClassHeaderDelegate>

@property (nonatomic, strong) FLCycleCarouselView *carouselView;
@property (nonatomic, strong) UIView           *carouselBgView;
@property (nonatomic, strong) NSMutableArray   *imagesGroup;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) UITableView      *groupTable;

@end

@implementation MusicHotViewController

#pragma mark - Lazy

- (UITableView *)groupTable {
    
    if (!_groupTable) {
        CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 88) : (SCREEN_HEIGHT - 64);
        _groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStyleGrouped];
        _groupTable.showsHorizontalScrollIndicator = NO;
        _groupTable.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        _groupTable.delegate = self;
        _groupTable.dataSource = self;
        _groupTable.emptyDataSetSource = self;
        _groupTable.emptyDataSetDelegate = self;
        _groupTable.separatorColor = [UIColor colorBoardLineColor];
        _groupTable.backgroundColor = [UIColor viewBackGroundColor];
        [_groupTable registerClass:[MusicClassHeaderView class] forHeaderFooterViewReuseIdentifier:kMusicClassesHeaderIdentifier];
        [_groupTable registerNib:[UINib nibWithNibName:@"MusicMoreListCell" bundle:nil] forCellReuseIdentifier:kMusicClassesCellIdentifier];
    }
    return _groupTable;
}

- (NSMutableArray *)imagesGroup
{
    if (!_imagesGroup) {
        
        _imagesGroup = [[NSMutableArray alloc] init];
    }
    return _imagesGroup;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"推荐";
    
    [self configuraTable];
    [self addRefreshing];
}

- (void)configuraTable
{
    self.groupTable.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5)];
        view.backgroundColor = [UIColor viewBackGroundColor];
        CGFloat marign = 10;
        CGFloat height = view.tj_height - marign * 2;
        self.carouselView = [[FLCycleCarouselView alloc] initWithFrame:CGRectMake(0, marign, SCREEN_WIDTH, height)];
        self.carouselView.delegate = self;
        self.carouselView.cornerRadius = 5;
        self.carouselView.autoScrollTime = 0.2;
        self.carouselView.placeholder = @"icon_loading_banner";
        [view addSubview:self.carouselView];
        _carouselBgView = view;
        view;
    });
    
    [self.view addSubview:self.groupTable];
}

- (void)addRefreshing {
    
    WeakSelf;
    self.groupTable.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadingHotObject];
    }];
    
    [self.groupTable.mj_header beginRefreshing];
}

// 重写
- (void)recoverRefresh {
    [super recoverRefresh];
    
    if (![self.groupTable.mj_header isRefreshing]) {
        
        [self.groupTable.mj_header beginRefreshing];
    }
}

- (void)endGroupRefreh {
    [XDProgressHUD hideHUD];
    
    if ([self.groupTable.mj_header isRefreshing]) {
        [self.groupTable.mj_header endRefreshing];
    }
    if ([self.groupTable.mj_footer isRefreshing]) {
        [self.groupTable.mj_footer endRefreshing];
    }
}

#pragma mark - MusicClassHeaderDelegate

- (void)header:(MusicClassHeaderView *)header DidSelectClassModel:(MusicClassModel *)model {
    if (!model.keywordId) {
        [self loadingHot];
        return;
    }
    
    MusicMoreListController *detailVC = [[MusicMoreListController alloc] init];
    detailVC.param = model;
    detailVC.isMore = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - InfiniteCarouselDelegate

- (void)carousel:(FLCycleCarouselView *)carousel didSelectItemAtModel:(BannerModel *)model {
    
    [self loadingHot];
}

- (void)loadingHot
{
    MusicClassModel *param = [MusicClassModel new];
    param.tname = @"榜单";
    param.categoryId = @"2"; //默认id
    MusicMoreListController *detailVC = [[MusicMoreListController alloc] init];
    detailVC.param = param;
    detailVC.isMore = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - networking

- (void)loadingHotObject
{
    NSDictionary *params = @{
                             @"categoryId": @"2",
                             @"contentType": @"album",
                             @"version": @"4.3.26.2",
                             @"device": @"ios",
                             @"scale": @(2),
                             };
    
    WeakSelf;
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[RequestManager manager] GET:url_music_Recommend parameters:params success:^(id  _Nullable responseObj) {
        [self endGroupRefreh];
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) return;
        
        if ([responseObj[@"msg"] isEqualToString:@"成功"]) {
            weakSelf.carouselBgView.backgroundColor = [UIColor colorWhiteColor];
            [self clearLastObjects];
            
            NSArray *banners   = responseObj[@"focusImages"][@"list"];
            NSArray *categorys = responseObj[@"categoryContents"][@"list"];
            
            [self.imagesGroup addObjectsFromArray:[BannerModel mj_objectArrayWithKeyValuesArray:banners]];
            [self.dataSource addObjectsFromArray:[MusicClassModel mj_objectArrayWithKeyValuesArray:categorys]];
            self.carouselView.imageURLStringsGroup = self.imagesGroup;
            [weakSelf.groupTable reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [self endGroupRefreh];
    }];
}

- (void)clearLastObjects
{
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    if (self.imagesGroup.count) {
        [self.imagesGroup removeAllObjects];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MusicClassModel *classes = self.dataSource[section];
    return classes.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicClassesCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (self.dataSource.count > indexPath.section) {
        MusicClassModel *classes = self.dataSource[indexPath.section];
        if (classes.list.count > indexPath.row) {
            cell.model = classes.list[indexPath.row];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MusicClassHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMusicClassesHeaderIdentifier];
    header.delegate = self;
    if (self.dataSource.count > section) {
        header.model = self.dataSource[section];;
    }
    return header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.dataSource.count > indexPath.section) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self loadingHot];
        }else {
            MusicClassModel *classes = self.dataSource[indexPath.section];
            if (classes.list.count > indexPath.row) {
                MusicPlayModel *param = classes.list[indexPath.row];
                MusicPlayListController *detailVC = [[MusicPlayListController alloc] init];
                detailVC.param = param;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.groupTable.mj_header beginRefreshing];
    });
}
@end
