//
//  LoginViewController.m
//  FunOnline
//
//  Created by Mac on 2018/5/3.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIImageView *screenView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel  *titleLabel;

@end

@implementation LoginViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configSubView];
    [self addConstraints];
}

- (void)configSubView
{
    UIImageView *screenView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logon_screen"]];
    [self.view addSubview:screenView];
    self.screenView = screenView;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"快速登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton setTitleColor:[UIColor colorWhiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    loginButton.layer.cornerRadius = 23.0;
    loginButton.layer.borderColor = [UIColor colorWhiteColor].CGColor;
    loginButton.layer.borderWidth = 1.5;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(LogonIn) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton = loginButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"当前可用登录方式";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWhiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"icon_logon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    self.closeButton = closeButton;
}

- (void)addConstraints {
    
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(70);
        make.right.equalTo(self.view).offset(-70);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.loginButton.mas_top).offset(-30);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}


#pragma mark - Logon action

- (void)LogonIn {
    [XDProgressHUD showHUDWithIndeterminate:@"Login..."];
    
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CacheManager sharedManager].isLogon = YES;
        [UD setBool:YES forKey:UD_LOGON_ISEXIT];
        [UD synchronize];
        
        if (weakSelf.logonDidFinisedBlock) {
            weakSelf.logonDidFinisedBlock();
        }
        [self dismiss];
    });
}

- (void)dismiss {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
