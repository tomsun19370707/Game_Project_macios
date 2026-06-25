//
//  XTWKWebViewController.m
//  xitu
//
//  Created by Gavin on 2019/5/30.
//  Copyright © 2019 xitu. All rights reserved.
//

#import "SRWKWebViewController.h"

#import "SRCookieManager.h"

static NSString *const estimatedProgress = @"estimatedProgress";
static NSString *const titleKey = @"title";


@interface SRWKWebViewMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, weak) SRWKWebViewController *criptMessageHandler;

+ (instancetype)WebViewMessageHandlerWithTarget:(id)target selector:(SEL)selector;

@end


@interface SRWKWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong)WKWebViewConfiguration *config;
@property (nonatomic, strong)WKUserContentController *userController;

@property (nonatomic, assign) BOOL hideNav;

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) UIButton *customBackBtn;

@property (nonatomic, strong) NSMutableDictionary <NSString *, SRWKWebViewMessageHandler *>*messageHandlerDic;
@property (nonatomic, strong)NSMutableArray<NSURL *> *redirectURLs;
@property (nonatomic, strong)UIButton *closeButton;

//@property (nonatomic,strong) WKWebViewJavascriptBridge* bridge;

@end


@implementation SRWKWebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self clearWbCache];
    [self setUI];
    [self addObserver];

}
- (void)setMainURL:(NSString *)mainURL {
    _mainURL = mainURL;
    if ([_mainURL containsString:@"hideNav=true"]) {
        self.hideNav = YES;
    }

}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
/**
 清理缓存
 */
- (void)clearWbCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}


- (void)dealloc {
    [self removeObserver];
    _wkWebView.navigationDelegate = nil;
    _wkWebView.UIDelegate = nil;
    [_wkWebView.configuration.userContentController removeAllUserScripts];
    [self clearmessageHandlerDic];
}

- (void)setUI {
    self.navigationItem.titleView = self.customTitleLabel;

    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight *0.25);
    tapButton.backgroundColor = [UIColor clearColor];
    [tapButton addTarget:self action:@selector(viewtap:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [tapButton addGestureRecognizer:longP];
    [self.view addSubview:tapButton];
    [self.view bringSubviewToFront:tapButton];


    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    [self.navigationController.navigationBar addSubview:self.closeButton];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        }
    }];


    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(ScreenHeight *0.25);
        make.left.right.bottom.mas_equalTo(self.view);
//        if (@available(iOS 11.0, *)) {
////            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        } else {
////            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
//            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
//        }
    }];
    
    if (self.mainURL && [self.mainURL length]) {
        [self loadWebViewWith:self.mainURL];
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)p {
    DLog(@"长按");
}
- (void)viewtap :(UITapGestureRecognizer *)tap {

    [UIView animateWithDuration:0.3 animations:^{
        self.view.mj_y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)superView {
    [superView addSubview:self.view];
    self.view.mj_y = ScreenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.mj_y = 0;
    }];
}
- (void)loadWebViewWith:(NSString *)linkStr {
    NSString *temUrlStr = [linkStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.isDecode) {
         temUrlStr = [temUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:temUrlStr];
    if (url) {
        [self configCookie];
        [self configUserAgent];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
//        SRUser *loginUser = SRUserManager.shared.user;
//        NSString *token = @"";
//        if ([loginUser.token isExist]) {
//            token = loginUser.token;
//            NSString *timestamp =[SRConvenientFunc dateWithNowSp];
//            NSString *sgin = [NSString stringWithFormat:@"token%@timestamp%@secret#&1827147",token,timestamp];
//            NSDictionary *dicHeaderField = @{@"deviceId":[[UIDevice currentDevice] uuid],
//                                             @"appVersion":[SRConvenientFunc getShortVersion],
//                                             @"clientType":@"appstore",
//                                             @"deviceName":[SRConvenientFunc getCurrentDeviceModel],
//                                             @"sign":[SRConvenientFunc sha1:sgin],
//                                             @"timestamp":timestamp,
//                                             @"token":token};
//            request.allHTTPHeaderFields = dicHeaderField;
//        }
        [self.wkWebView loadRequest:request];
        
//        [self registerBridgeHandler];
    }else{
        #warning 待处理链接不存在的情况;
    }
    
}

- (void)backToLastPage {
    [self goBack];
    
    if (@available(iOS 11, *)) {
    }
    else {
        [self analyseWebviewParams:self.wkWebView];
    }
}

//- (void)registerBridgeHandler {
//    __weak typeof(self)weakSelf = self;
//    [self.bridge registerHandler:@"postMessage" handler:^(id data, WVJBResponseCallback responseCallback) {
//        SRLOG(@"ObjC Echo called with: %@", data);
//        NSString * str  = data;
//        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
////        if ([[NSString stringWithFormat:@"%@",dic[@"type"]]  isEqualToString:@"userZone"]) {//去个人中心
////            QTPersonalViewController *vc =[[QTPersonalViewController alloc] initWithUserId:[dic[@"data"][@"userId"] longLongValue]];
////            [weakSelf.navigationController pushViewController:vc animated:YES];
////        }
//        responseCallback(data);
//    }];
//}

#pragma mark - Observer
- (void)addObserver {
    //网页title监听
    [_wkWebView addObserver:self forKeyPath:titleKey options:NSKeyValueObservingOptionNew context:NULL];
    [_wkWebView addObserver:self forKeyPath:estimatedProgress options:NSKeyValueObservingOptionNew context:NULL];
}


- (void)removeObserver {
    //网页title监听移除
    [_wkWebView removeObserver:self forKeyPath:titleKey];
    [_wkWebView removeObserver:self forKeyPath:estimatedProgress];
}

- (void)setWebViewContentInset:(UIEdgeInsets)contentInset {
    _wkWebView.scrollView.contentInset = contentInset;
}

- (void)setNavTitleColor:(UIColor *)titleColor {
    self.customTitleLabel.textColor = titleColor;
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.customBackBtn];
    return backItem;
}

- (void)updateBackItemImage:(UIImage *)image {
    [self.customBackBtn setImage:image forState:(UIControlStateNormal)];
}

- (NSString *)nonullWebTitle {
    if (self.customTitleLabel.text.length > 0) {
        return self.customTitleLabel.text;
    }
    return @"";
}

- (NSString *)currentUrl {
    if ([self.wkWebView.URL.absoluteString length]) {
        return self.wkWebView.URL.absoluteString;
    }
    return @"";
}

//- (WKWebViewJavascriptBridge *)bridge {
//    if (!_bridge) {
//        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
//        [_bridge setWebViewDelegate:self];
////        [WebViewJavascriptBridge enableLogging];
//    }
//    return _bridge;
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.wkWebView){
        if ([keyPath isEqualToString:titleKey]) {
            self.customTitleLabel.text = self.wkWebView.title;
        }else if ([keyPath isEqualToString:estimatedProgress]){
            self.progressView.progress = self.wkWebView.estimatedProgress;
            if (self.wkWebView.estimatedProgress == 1) {
                [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.progressView.hidden = YES;
                    }
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)sr_customGoback {
    [self goBack];
}
- (void)goBack {
    //如果有历史网页
    if (self.wkWebView.canGoBack) {
        for (NSURL *url in self.redirectURLs) {
            WKBackForwardListItem *backItem = self.wkWebView.backForwardList.backItem;
            if ([url.absoluteString isEqualToString:backItem.initialURL.absoluteString]) {
                NSInteger index = [self.wkWebView.backForwardList.backList indexOfObject:backItem];
                index -= 1;
                if (index >= 0) {
                    WKBackForwardListItem *targetItem = [self.wkWebView.backForwardList.backList objectAtIndex:index];
                    [self.wkWebView goToBackForwardListItem: targetItem];
                    [self.redirectURLs removeObject:url];
                }else{
                    if (self.navigationController) {
                        if (self.presentingViewController && 1 == self.navigationController.viewControllers.count) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }else{
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                return;
            }
        }
        [self.wkWebView goBack];
    }else{//浏览器首页
        if (self.navigationController) {
            if (self.presentingViewController && 1 == self.navigationController.viewControllers.count) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)close {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webviewEndLoad:(WKWebView *)webView {
    self.closeButton.hidden =  !webView.canGoBack;
}

- (void)clearmessageHandlerDic {
    [self.messageHandlerDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRWKWebViewMessageHandler * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.userController removeScriptMessageHandlerForName:key];
    }];
}

- (void)addScriptMessageHandlerWithTarget:(id)target selector:(SEL)selector name:(NSString *)name {
    if (target && selector && name.length > 0) {
        SRWKWebViewMessageHandler *handler = [SRWKWebViewMessageHandler WebViewMessageHandlerWithTarget:target selector:selector];
        handler.criptMessageHandler = self;
        if (![self.messageHandlerDic.allKeys containsObject:name]) {
            [self.userController addScriptMessageHandler:handler name:name];
            [self.messageHandlerDic setObject:handler forKey:name];
        }
        else {
            DLog(@"已存在对应的方法：[%@ %@] for name(%@) add faild", target, NSStringFromSelector(selector), name);
        }
    }
}

- (void)evaluateJavaScript:(NSString *)script completionHandler:(void (^ _Nullable)(_Nullable id object, NSError * _Nullable error))completionHandler {
    [self.wkWebView evaluateJavaScript:script completionHandler:completionHandler];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DLog(@"web 调用 oc : [target %@:%@]", message.name, message.body);
    if ([self.messageHandlerDic.allKeys containsObject:message.name]) {
        SRWKWebViewMessageHandler *handler = self.messageHandlerDic[message.name];
        if (handler.target && [handler.target respondsToSelector:handler.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [handler.target performSelector:handler.selector withObject:message.body];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark-- WKWebView Delegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *urlStr = url.absoluteString;
    if([urlStr containsString:@""]) {
        int64_t roomId = [[urlStr stringByReplacingOccurrencesOfString:@"" withString:@""] longLongValue];
        if (roomId != 0) {
            [self jumpMineLivingRoomWith:roomId];
        }
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
#pragma mark - 跳转到直播间
/// 跳转到直播间
- (void)jumpMineLivingRoomWith:(int64_t)roomId {
    //[[SRTypeManager shared] typeManagerWith:SRUniversalJumpTypeLiveRoom andValue:[NSString stringWithFormat:@"%lld",roomId]];
}

//接收到相应数据后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}

// 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (webView.URL) {
        [self.redirectURLs addObject:webView.URL];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"didFailProvisionalNavigation:%@", error);
    [self webviewEndLoad:webView];
}
// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//
//}

// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //禁掉双指放大、缩放手势
    NSString *injectionJSString = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    //禁掉长按元素手势
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    self.progressView.hidden = YES;
    [self webviewEndLoad:webView];
    [self analyseWebviewParams:webView];
}
//跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self webviewEndLoad:webView];
}
//// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//
//}
//9.0才能使用，web内容处理中断时会触发
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//
//}

- (void)analyseWebviewParams:(WKWebView *)webview {
}

- (UILabel *)customTitleLabel {
    if (!_customTitleLabel) {
        _customTitleLabel = [[UILabel alloc] init];
        _customTitleLabel.textColor = UIColor.blackColor;
        _customTitleLabel.font = [UIFont systemFontOfSize:16];
        _customTitleLabel.frame = CGRectMake(0, 0, ScreenWidth - 160, 44);
        _customTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _customTitleLabel;
}

- (UIButton *)customBackBtn {
    if (!_customBackBtn) {
        _customBackBtn = [[UIButton alloc] init];
//        [_customBackBtn setImage:SRImageWithName(@"nav_blackBack") forState:UIControlStateNormal];
        [_customBackBtn addTarget:self action:@selector(backToLastPage) forControlEvents:(UIControlEventTouchUpInside)];
        _customBackBtn.frame = CGRectMake(0, 0, 10, 17); // iOS10.3以下部分系统如果不设置frame，按钮会显示不出来
//        [_customBackBtn hx_setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _customBackBtn;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.hidden= YES;
    }
    return _progressView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero
                                        configuration:self.config];
        _wkWebView.scrollView.scrollEnabled = NO;
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _wkWebView.navigationDelegate = self;
//        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.UIDelegate = self;
        _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _wkWebView;
}


- (WKWebViewConfiguration *)config {
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.allowsInlineMediaPlayback = YES;
        _config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _config.userContentController = self.userController;
        _config.processPool = [WKProcessPoolMannager shared].pool;
    }
    return _config;
}
- (WKUserContentController *)userController {
    if (!_userController) {
        _userController = self.config.userContentController;
        NSString *source = [[NSHTTPCookieStorage sharedHTTPCookieStorage] documentCookieFormat];
        [_userController addUserScript:
        [[WKUserScript alloc] initWithSource:source
                                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                             forMainFrameOnly:NO]];
    }
    return _userController;
}

- (NSMutableDictionary<NSString *,SRWKWebViewMessageHandler *> *)messageHandlerDic {
    if (!_messageHandlerDic) {
        _messageHandlerDic = [NSMutableDictionary dictionary];
    }
    return _messageHandlerDic;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(50, 0, 60, 44);
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"sr_dismiss_back_black"] forState:UIControlStateNormal];
        _closeButton.hidden = YES;
        [_closeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _closeButton;
}

- (NSMutableArray<NSURL *> *)redirectURLs {
    if (!_redirectURLs) {
        _redirectURLs = [NSMutableArray array];
    }
    return _redirectURLs;
}

- (void)configCookie {
//    NSString *host = self.mainURL.linkUrl.host;
//    if ([host containsString:XTAppDomain]) {
//        [self.userController addUserScript:
//         [[WKUserScript alloc] initWithSource:[self xtH5DocumentCookieFormat]
//                                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                             forMainFrameOnly:NO]];
//    }
//    else {
        [self.userController addUserScript:
         [[WKUserScript alloc] initWithSource:[self otherH5DocumentCookieFormat]
                                injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                             forMainFrameOnly:YES]];
//    }
}

- (NSString *)xtH5DocumentCookieFormat {
//    NSString *host = self.mainURL.linkUrl.host;
//    NSInteger loginState = [SRLOGinManager isLogin]?1:0;
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    cookieDic[@"XT_GTTS_TK"] = loginState ? [XTUserManager shared].user.accesstoken :@"";
//    cookieDic[@"XT_GTTS_LOGN"] = @(loginState);
//    cookieDic[@"XT_APP_VERSION"] = [self getShortVersion];
//    NSMutableString *formatStr = @"".mutableCopy;
//    for (NSString *key in cookieDic.allKeys) {
//        if (cookieDic[key]) {
//            [formatStr appendFormat:@"document.cookie = '%@=%@;path=/;domain=%@';", key, cookieDic[key], host];
//        }
//    }
    NSString *formatStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    return formatStr;
}

- (NSString *)otherH5DocumentCookieFormat {
//    NSString *host = self.mainURL.linkUrl.host;
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    cookieDic[@"XT_GTTS_TK"] = @"";
//    cookieDic[@"XT_GTTS_LOGN"] = @(0);
//    cookieDic[@"XT_APP_VERSION"] = [self getShortVersion];
//    NSMutableString *formatStr = @"".mutableCopy;
//    for (NSString *key in cookieDic.allKeys) {
//        if (cookieDic[key]) {
//            [formatStr appendFormat:@"document.cookie = '%@=%@;path=/;domain=%@';", key, cookieDic[key], host];
//        }
//    }
    NSString *formatStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    return formatStr;
}

- (void)configUserAgent {
    __weak typeof(self) weakSelf = self;
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable agent, NSError * _Nullable error) {
        NSString *oldAgent = agent;
        // 给User-Agent添加额外的信息
        NSString *newAgent = [NSString stringWithFormat:@"%@;QP_APP_VERSION/%@", oldAgent, [self getShortVersion]];
        weakSelf.wkWebView.customUserAgent = newAgent;
    }];
    
    // ios8通过如下方式
//    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable agent, NSError * _Nullable error) {
//        NSString *oldAgent = agent;
//        // 给User-Agent添加额外的信息
//        NSString *newAgent = [NSString stringWithFormat:@"%@;%@", oldAgent, @"custom-app"];
//        // 设置global User-Agent
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//    }];
}



- (NSString *)getShortVersion {
    static NSString *version = nil;
    if (!version) {
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    }
    return version;
}

@end

@interface WKProcessPoolMannager ()

@end
@implementation WKProcessPoolMannager

+ (WKProcessPoolMannager *)shared {
    static WKProcessPoolMannager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared  = [[WKProcessPoolMannager alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pool = [[WKProcessPool alloc] init];
    }
    return self;
}

@end


@implementation SRWKWebViewMessageHandler

+ (instancetype)WebViewMessageHandlerWithTarget:(id)target selector:(SEL)selector {
    SRWKWebViewMessageHandler *messageHandler  = [[SRWKWebViewMessageHandler alloc] init];
    messageHandler.target = target;
    messageHandler.selector = selector;
    return messageHandler;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.criptMessageHandler) {
        [self.criptMessageHandler userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
