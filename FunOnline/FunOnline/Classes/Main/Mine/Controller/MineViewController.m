//
//  MoreViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import <SDWebImageManager.h>
#import "IBWaterWaveView.h"

#import "FavoriteViewController.h"
#import "FeedBackViewController.h"
#import "LoginViewController.h"

static NSString *const kMineCellReuseIdentifier = @"kMineCellReuseIdentifier";

@interface MineViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel     *userNameLabel;
@property (nonatomic, strong) UIButton    *loginButton;
@property (nonatomic, strong) NSArray     *mineObjets;

@end

@implementation MineViewController

- (NSArray *)mineObjets
{
    if (!_mineObjets) {
        
        _mineObjets = @[
                        [MineModel initWithTitle:@"我的收藏" image:@"mine_star"],
                        [MineModel initWithTitle:@"给我评价" image:@"mine_store"],
                        [MineModel initWithTitle:@"意见反馈" image:@"mine_feedback"],
                        [MineModel initWithTitle:@"清除缓存" image:@"mine_clear"]
                        ];
    }
    return _mineObjets;
}

#pragma mark - Life Cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    
    [self configSubview];
}

- (void)configSubview
{
    CGFloat h = iPhone5 ? SCREEN_HEIGHT * 0.4 : SCREEN_WIDTH * 0.62;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    
    // d0e765, 33aab4
    IBWaterWaveView *waveView = [[IBWaterWaveView alloc] initWithFrame:headerView.bounds startColor:IBHexColorA(0xd0e765, 0.3) endColor:IBHexColorA(0x33aab4, 0.9)];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[self reloadImage]];
    logoImageView.frame = CGRectMake(0, 0, 90, 90);
    logoImageView.center = CGPointMake(headerView.mj_w*0.5, headerView.mj_h*0.5);
    logoImageView.layer.cornerRadius = 45.0;
    logoImageView.layer.borderWidth = 3.0;
    logoImageView.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    logoImageView.layer.masksToBounds = YES;
    [headerView addSubview:waveView];
    [headerView addSubview:logoImageView];
    self.tableView.tableHeaderView = headerView;
    self.logoImageView = logoImageView;
    
    CGFloat labelY = CGRectGetMaxY(logoImageView.frame) + 5;
    CGFloat labelW = SCREEN_WIDTH - 30*2;
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, labelY, labelW, 20)];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.textColor = [UIColor colorDarkTextColor];
    self.userNameLabel.text = [self reloadName];
    [headerView addSubview:self.userNameLabel];
    
    WeakSelf;
    waveView.waveChangeBlock = ^(CGFloat currentY) {
        CGRect frame = logoImageView.frame;
        frame.origin.y = currentY - CGRectGetHeight(logoImageView.frame) - 5;
        logoImageView.frame = frame;
        weakSelf.userNameLabel.tj_y = CGRectGetMaxY(frame) + 5;
    };
    
    CGFloat height = iPhoneX ? (SCREEN_HEIGHT - 83) : (SCREEN_HEIGHT - 49);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:kMineCellReuseIdentifier];
    self.tableView.tableFooterView = [self defaultSetFooter];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (UIView *)defaultSetFooter
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWhiteColor];
    self.loginButton = [[UIButton alloc] initWithFrame:view.bounds];
    [self.loginButton setTitle:[self reloadLogon] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(logonIn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.loginButton];
    return view;
}

- (void)logonIn {
    if ([CacheManager sharedManager].isLogon) {
        [self showLogonSheet]; //退出
        return;
    }
    
    WeakSelf;
    LoginViewController *logonVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:logonVC animated:YES];
    logonVC.logonDidFinisedBlock = ^{
        [XDProgressHUD showHUDWithLongText:@"登录成功" hideDelay:1.0];
        [weakSelf updateObjects];
    };
}

- (void)logonOut {
    [XDProgressHUD showHUDWithIndeterminate:@"Logout..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XDProgressHUD hideHUD];
        
        [CacheManager sharedManager].isLogon = NO;
        [UD setBool:NO forKey:UD_LOGON_ISEXIT];
        [UD synchronize];
        
        [self updateObjects];
    });
}

- (void)updateObjects
{
    self.userNameLabel.text  = [self reloadName];
    self.logoImageView.image = [self reloadImage];
    [self.loginButton setTitle:[self reloadLogon] forState:UIControlStateNormal];
}

- (NSString *)reloadLogon
{
    return [CacheManager sharedManager].isLogon ? @"退出登录" : @"登录";
}

- (NSString *)reloadName {
    
    return [CacheManager sharedManager].isLogon ? @"FunOnline235" : @"";
}

- (UIImage *)reloadImage
{
    UIImage *logoImage = nil;
    if ([CacheManager sharedManager].isLogon) {
        logoImage = [UIImage imageNamed:@"mine_exist_logo"];
    }else {
        logoImage = [UIImage imageNamed:@"icon_default_avatar"];
    }
    return logoImage;
}

#pragma mark - TableView for data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mineObjets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReuseIdentifier];
    if (self.mineObjets.count > indexPath.row) {
        cell.model = self.mineObjets[indexPath.row];
        if (indexPath.row == self.mineObjets.count-1) {
            cell.hideLine  = YES;
            cell.hideArrow = YES;
        }
    }
    return cell;
}

#pragma mark - TableView for delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self jumpFavorite];
    }else if (indexPath.row == 1) {
        [self showTips];
    }else if (indexPath.row == 2) {
        [self jumpFeedBack];
    }else {
        [self showClearSheet];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return iPhone5 ? 44 : 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)showClearSheet {
    
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeTitle(@"温馨提示")
    .LeeContent(@"确定清除当前缓存吗? 图片会被清除")
    .LeeContent([self getCachesSize])
    .LeeAction(@"YES", ^{
        [weakSelf animClear];
    })
    .LeeCancelAction(@"NO", ^{
        // 点击事件Block
    })
    .LeeShow();
}

- (void)showLogonSheet
{
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeContent(@"是否退出登录")
    .LeeAction(@"YES", ^{
        [weakSelf logonOut];
    })
    .LeeCancelAction(@"NO", ^{
        // 点击事件Block
    })
    .LeeShow();
}

#pragma mark - Other For Handles

- (void)jumpFavorite
{
    FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
    [self.navigationController pushViewController:favoriteVC animated:YES];
}

- (void)jumpFeedBack
{
    FeedBackViewController *feedBackVC = [[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

- (void)showTips
{
    [LEEAlert alert].config
    .LeeTitle(@"温馨提示")
    .LeeContent(@"应用上架AppStore后，就可以评论了哟")
    .LeeAction(@"OK", ^{
        
    })
    .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
    .LeeShow();
}

- (void)animClear {
    [XDProgressHUD showHUDWithIndeterminate:@"正在清除..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XDProgressHUD hideHUD];
        
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    });
}

- (NSString *)getCachesSize {
    NSInteger caches = [[SDImageCache sharedImageCache] getSize];
    
    if (caches) {
        if (caches>1024.0*1024.0) {
            return [NSString stringWithFormat:@"当前缓存 %.2fMB", caches/1024.0/1024.0];
        }else if (caches>1024.0) {
            return [NSString stringWithFormat:@"当前缓存 %.2fKB", caches/1024.0];
        }else if (caches>0) {
            return [NSString stringWithFormat:@"当前缓存 %.2luB", caches];
        }
    }
    return @"当前缓存 0KB";
}

@end
