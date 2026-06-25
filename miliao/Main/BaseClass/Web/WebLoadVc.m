//
//  WebLoadVc1.m
//
//  类介绍说明：
//
//

#import "WebLoadVc.h"

// DTO

// View

// 下级控制器

@interface WebLoadVc ()<WKUIDelegate, WKNavigationDelegate,UIScrollViewDelegate>
/** DTO */
//@property (nonatomic,strong) <#DTOHandle#> *handle;
@property (nonatomic, strong) WKWebView * webView;
/** 网页加载进度视图*/
@property (nonatomic, strong) UIProgressView * progressView;
/** 网页高度*/
@property (nonatomic, assign) CGFloat contentHeight;
/** 延迟时间*/
@property (nonatomic, assign) CGFloat delayTime;
@end

@implementation WebLoadVc

#pragma mark -
#pragma mark 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    self.progressView.frame = CGRectMake(0, insets.top + 2, self.view.frame.size.width, 2);
}
- (void)dealloc{
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // NavBar
    [self initNavBar];
    // 布局视图
    [self initContentView];
    // Rac
    [self initRacChain];
    // 网络请求
    [self initRequestData];
}

#pragma mark -
#pragma mark --- init nav
- (void)initNavBar {
    if (self.titleStr) {
        self.navigationBar.title = self.titleStr ;
    }else{
        self.navigationBar.title = @"详情" ;
    }
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.view.backgroundColor = UIColor.whiteColor ;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    /** 添加监测网页加载进度的观察者*/
    NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    /** KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件*/
    /** 监控进度 */
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
    
    /** title*/
    [self.webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    
}
#pragma mark --
#pragma mark --- Setter
-(void)setWebUrl:(NSString *)webUrl
{
    if (![webUrl hasPrefix:@"http"]) {
        webUrl = [NSString stringWithFormat:@"https://%@",webUrl];
    }
    webUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _webUrl = webUrl ;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    /** load*/
    [self.webView loadRequest:request];
}
-(void)setWebHtml:(NSString *)webHtml
{
    _webHtml = webHtml ;
    
    NSString *strTemp = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@%@</div>",WebLoadPrefixJS,webHtml];
    /** load*/
    [self.webView loadHTMLString:strTemp baseURL:nil];
}
#pragma mark -
#pragma mark --- Getter
- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
- (WKWebView *)webView{
    if(!_webView){
       //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        config.allowsInlineMediaPlayback = YES;
        
        /** 以下代码适配文本大小*/
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        //初始化
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(12, NavBarHeight, SCREEN_WIDTH - 12 * 2, SCREEN_HEIGHT - NavBarHeight) configuration:config];

        _webView.scrollView.delegate = self;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        /** 开始右滑返回手势*/
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}
#pragma mark --
#pragma mark --- Method

#pragma mark --
#pragma mark --- observerDelegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress < 1.0) {
            self.delayTime = 1 - self.webView.estimatedProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
        });
        
    }else if ([keyPath isEqualToString:@"title"]) {
        self.navigationBar.title = self.webView.title;
        
    }
}

//解决加载图文不全的问题
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y > 0) {
        if([UIDevice currentDevice].systemVersion.floatValue >= 10) {
            [self.webView setNeedsLayout];
        }
    }
}

#pragma mark --
#pragma mark -- WKNavigationDelegate --

// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"didStartProvisionalNavigation------ %@", navigation);
}

// 页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"didFinishNavigation-------%@", navigation);
    
    // 注入JavaScript禁止缩放
    NSString *js = @"document.documentElement.style.webkitTouchCallout='none';";
    js = [js stringByAppendingString:@"document.documentElement.style.webkitUserSelect='none';"];
    js = [js stringByAppendingString:@"var meta = document.createElement('meta');"];
    js = [js stringByAppendingString:@"meta.name = 'viewport';"];
    js = [js stringByAppendingString:@"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no';"];
    js = [js stringByAppendingString:@"document.getElementsByTagName('head')[0].appendChild(meta);"];
    
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            DLog(@"注入JS错误: %@", error.localizedDescription);
        }
    }];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"didFailProvisionalNavigation-------   %@\nerror ------ %@", navigation, error);
    [self.progressView setProgress:0.0f animated:NO];
}

// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"didCommitNavigation ------ %@", navigation);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    DLog(@"\n-------decidePolicyForNavigationAction -------- %@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    DLog(@"decidePolicyForNavigationResponse ------- %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end
