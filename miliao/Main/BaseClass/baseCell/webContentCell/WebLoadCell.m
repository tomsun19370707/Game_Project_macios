//
//  WebLoadCell.m
//  PodFullDemo
//
//  Created by 李东阳 on 2019/12/27.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "WebLoadCell.h"
#import <WebKit/WebKit.h>

@interface WebLoadCell ()<WKUIDelegate, WKNavigationDelegate,UIScrollViewDelegate>
/** View */
@property (nonatomic, strong) WKWebView * webView;
/** 网页高度*/
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation WebLoadCell

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}
- (void)dealloc{
    /** 移除观察者*/
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    [self.contentView addSubview:self.webView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    /** 添加监测网页加载进度的观察者*/
    NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    /** 监控高度 */
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];
}

#pragma mark -
#pragma mark --- Getter
- (WKWebView *)webView{
    if(!_webView){
       //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        config.allowsInlineMediaPlayback = YES;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        //初始化
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(12, 40, SCREEN_WIDTH - 12 * 2, 10) configuration:config];
        
        _webView.scrollView.delegate = self;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        /** 透明背景*/
        _webView.opaque = NO;
        _webView.backgroundColor = UIColor.clearColor;
        
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO ;
        /** 开始右滑返回手势*/
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}
#pragma mark --
#pragma mark --- Setter
-(void)setWebHtml:(NSString *)webHtml
{
    NSString *strTemp = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@%@</div>",WebLoadPrefixJS,webHtml];
    /** load*/
    [self.webView loadHTMLString:strTemp baseURL:nil];
}
-(void)setType:(WebLoadCellType)type
{
    _type = type ;
    if (type == WebLoadCellTypeHeaderNoExit) {
        self.lab.hidden = YES ;
        self.mark.hidden = YES ;
        [self.webView setTop:0];
    }
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method

#pragma mark --
#pragma mark --- observerDelegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.contentHeight != self.webView.scrollView.contentSize.height) {
            self.contentHeight = self.webView.scrollView.contentSize.height;
            DLog(@"网页实际高度====%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
            /** 设置web */
            [self.webView setHeight:self.contentHeight];
            if (self.webHeight) {
                /** 有header 情况下，默认从40开始*/
                self.webHeight(self.contentHeight + self.webView.top);
            }
        }
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
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"didFailProvisionalNavigation-------   %@\nerror ------ %@", navigation, error);
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

