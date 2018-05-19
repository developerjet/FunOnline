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
#import "InfiniteCarouselView.h"
#import "MusicClassHeaderView.h"
#import "MusicMoreListCell.h"
#import "MusicClassModel.h"
#import "BannerModel.h"

static NSString *const kMusicClassesCellIdentifier   = @"kMusicClassesCellIdentifier";
static NSString *const kMusicClassesHeaderIdentifier = @"kMusicClassesHeaderIdentifier";

@interface MusicHotViewController ()<InfiniteCarouselDelegate>

@property (nonatomic, strong) InfiniteCarouselView *carouselView;
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
        _groupTable.separatorColor = [UIColor colorBoardLineColor];
        _groupTable.delegate = self;
        _groupTable.dataSource = self;
        _groupTable.emptyDataSetSource   = self;
        _groupTable.emptyDataSetDelegate = self;
        _groupTable.backgroundColor = [UIColor colorBackGroundColor];
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
        view.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        CGFloat height = view.tj_height - 20;
        self.carouselView = [[InfiniteCarouselView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, height)];
        self.carouselView.delegate = self;
        self.carouselView.cornerRadius = 5;
        self.carouselView.autoScrollTime = 0.2;
        self.carouselView.placeholder = @"icon_banner_placeholder";
        [view addSubview:self.carouselView];
        view;
    });
    
    [self.view addSubview:self.groupTable];
}

- (void)addRefreshing {
    
    WeakSelf;
    self.groupTable.mj_header = [FLRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadRecommend];
    }];
    
    [self.groupTable.mj_header beginRefreshing];
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

// 重写父类方法
- (void)recoverRefresh {
    [super recoverRefresh];
    
    if (![self.groupTable.mj_header isRefreshing]) {
        [self.groupTable.mj_header beginRefreshing];
    }
}

#pragma mark - InfiniteCarouselDelegate

- (void)carousel:(InfiniteCarouselView *)carousel didSelectItemAtModel:(BannerModel *)model {
    
    [self jumpToMore];
}

- (void)jumpToMore
{
    MusicClassModel *param = [[MusicClassModel alloc] init];
    param.tname = @"榜单";
    param.categoryId = @"2"; //默认id
    MusicMoreListController *detailVC = [[MusicMoreListController alloc] init];
    detailVC.param = param;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Networking

- (void)loadRecommend
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
            [self clearLastObjects];
            NSArray *bannerObjects   = responseObj[@"focusImages"][@"list"];
            NSArray *categoryObjects = responseObj[@"categoryContents"][@"list"];
            
            [self.imagesGroup addObjectsFromArray:[BannerModel mj_objectArrayWithKeyValuesArray:bannerObjects]];
            [self.dataSource addObjectsFromArray:[MusicClassModel mj_objectArrayWithKeyValuesArray:categoryObjects]];
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
    if (self.dataSource.count > section) {
        MusicClassModel *model = self.dataSource[section];
        header.classLabel.text = model.title;
    }
    return header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.dataSource.count > indexPath.section) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self jumpToMore];
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

#pragma mark - <DZNEmptyDataSetSource>
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"icon_loading_image"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"请点击重试哟~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor colorThemeColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf restRefresh];
    });
}

- (void)restRefresh {
    
    if (![self.groupTable.mj_header isRefreshing]) {
        [self.groupTable.mj_header beginRefreshing];
    }
    if (![self.groupTable.mj_header isRefreshing]) {
        [self.groupTable.mj_header beginRefreshing];
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return SCREEN_HEIGHT * 0.2;
}

@end
