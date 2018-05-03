//
//  WebbrowerViewController.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WebBrowseViewController.h"
#import <WebKit/WebKit.h>
#import "NewsModel.h"

@interface WebBrowseViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *browseView;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation WebBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleString;
    
    [self initNavItem];
    [self configWkWeb];
    [self loadRequest];
}

- (void)initNavItem
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setImage:[UIImage imageNamed:@"favorite_normal"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"favorite_select"] forState:UIControlStateSelected];
    [startButton addTarget:self action:@selector(starNewsEvent:) forControlEvents:UIControlEventTouchUpInside];
    [startButton sizeToFit];
    UIView *customView = [[UIView alloc] initWithFrame:startButton.bounds];
    [customView addSubview:startButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.startButton = startButton;
    
    [self starSetup:self.model];
}

- (void)configWkWeb
{
    self.browseView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.browseView.UIDelegate = self;
    self.browseView.navigationDelegate = self;
    self.browseView.backgroundColor = [UIColor whiteColor];
    self.browseView.allowsBackForwardNavigationGestures = YES;
    self.browseView.configuration.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        self.browseView.configuration.mediaTypesRequiringUserActionForPlayback = NO;
    }
    [self.view addSubview:self.browseView];
}

- (void)starSetup:(NewsModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[CacheManager sharedManager] isStartNewsWithModel:model]) {
            self.startButton.selected = YES;
        }else {
            self.startButton.selected = NO;
        }
    });
}

#pragma mark - action

- (void)starNewsEvent:(UIButton *)button {
    if (!self.model) {
        [XDProgressHUD showHUDWithText:@"当前无法收藏" hideDelay:1.0];
        return;
    }
    button.selected = !button.selected;
    
    if (button.selected) {
        self.model.isStar = YES;
        [[CacheManager sharedManager] startNewsWithModel:self.model];
        [XDProgressHUD showHUDWithText:@"收藏成功" hideDelay:1.0];
    }else {
        self.model.isStar = NO;
        [[CacheManager sharedManager] unStartNewsWithModel:self.model];
        [XDProgressHUD showHUDWithText:@"取消收藏" hideDelay:1.0];
    }
    
    // 发出收藏列表刷新通知
    [NC postNotificationName:NC_Reload_News object:nil];
}

- (void)loadRequest
{
    [XDProgressHUD showHUDWithIndeterminate:@"Loading..."];
    
    NSURL *aboutString = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aboutString cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    [self.browseView loadRequest:request];
}

#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [XDProgressHUD hideHUD];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [XDProgressHUD hideHUD];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [XDProgressHUD hideHUD];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

@end
