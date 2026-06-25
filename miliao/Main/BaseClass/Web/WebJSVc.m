//
//  MERedVc.m
//
//  类介绍说明：
//
//

#import "WebJSVc.h"
// DTO

// View

// 下级控制器

@interface WebJSVc ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
/** 加载提示框*/
@property (nonatomic,strong) UIActivityIndicatorView *activity;
/** 加载次数*/
@property (nonatomic,assign) int loadCount;
/** 网页*/
@property (nonatomic,strong) WKWebView *web;
@end

@implementation WebJSVc

#pragma mark -
#pragma mark 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 调用JS方法,避免循环引用*/
    [self.web.configuration.userContentController addScriptMessageHandler:self name:@"jsFunc"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /** 调用JS方法,避免循环引用*/
    [self.web.configuration.userContentController removeScriptMessageHandlerForName:@"jsFunc"];
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
    self.navigationBar.type = BaseNavBarTypeDarkMode ;
    self.navigationBar.backgroundColor = UIColor.clearColor ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    /** 背景颜色*/
    self.view.backgroundColor = UIColor.whiteColor ;
    /** web*/
    [self.view addSubview:self.web];
    /** ac*/
    [self.view addSubview:self.activity];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
   
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 加载url*/
    [self loadWebUrlHandle];
}

#pragma mark -
#pragma mark --- Getter
-(WKWebView *)web
{
    if (!_web) {
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
        _web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_FULL) configuration:config];
//        _web.scrollView.delegate = self;
        _web.navigationDelegate = self;
        _web.UIDelegate = self;
        
        _web.scrollView.showsHorizontalScrollIndicator = NO;
        /** 开始右滑返回手势*/
        _web.allowsBackForwardNavigationGestures = YES;
        if (@available(iOS 11.0, *)) {
            _web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _web ;
}
-(UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activity.backgroundColor = [UIColor grayColor];
        _activity.layer.masksToBounds = YES;
        _activity.layer.cornerRadius = 8;
        [_activity setCenter:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 60)];
    }
    return _activity;
}


#pragma mark --
#pragma mark --- Method
/** 加载url*/
- (void)loadWebUrlHandle
{
    if (![self.webUrl hasPrefix:@"http"]) {
        self.webUrl = [NSString stringWithFormat:@"https://%@",self.webUrl];
    }
    
//    self.webUrl = [self.webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"_webUrl=====%@",self.webUrl);
    
    /** 加载数据*/
    NSURL *urls = [NSURL URLWithString:self.webUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urls cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:28.0];
    [self.web loadRequest:request];

    /** 初始化*/
    self.loadCount = 1;
}

-(void)back
{
    if ([self.web canGoBack]) {
        [self.web goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    /** 直接返回上一级，关闭页面*/
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark --- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DLog(@"webViewDidStartLoad");
    
    [self.activity startAnimating];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.activity stopAnimating];
    
    if (self.loadCount <= 3) {
        [self.web removeFromSuperview];

        NSURL *urls=[NSURL URLWithString:_webUrl];
        NSURLRequest *request=[NSURLRequest requestWithURL:urls];
        [self.web loadRequest:request];
        self.loadCount += 1 ;
    }
    DLog(@"网页加载次数：%d",self.loadCount);
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.activity stopAnimating];
    
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

#pragma mark --
#pragma mark --- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"jsFunc"]) {
        NSDictionary *jsData = message.body;
        DLog(@"/n---%@++++%@", message.name, jsData);
        
        /** 1.积分-任务广场
         2.战力-趣购
         3.金币-合成金币-H5
         4.广告-广告
         5.邀请-分享朋友圈
         6.去购买-会员专区
         7.砸金蛋
         */
        NSString *value = jsData[@"key"];
        NSString *type = [value stringByReplacingOccurrencesOfString:@"t" withString:@""];
        switch (type.intValue) {
            case 1:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }
}

/** OC调用JS*/
- (void)ocToJs{
    /** changeColor()是JS方法名，completionHandler是异步回调block*/
    NSString *jsString = [NSString stringWithFormat:@"changeColor('%@')", @"Js颜色参数"];
    [self.web evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        DLog(@"改变HTML的背景色");
    }];
    
    /** 改变字体大小 调用原生JS方法*/
    NSString *jsFont = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", arc4random()%99 + 100];
    [self.web evaluateJavaScript:jsFont completionHandler:nil];
    
    NSString * path =  [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"png"];
    NSString *jsPicture = [NSString stringWithFormat:@"changePicture('%@','%@')", @"pictureId",path];
    [self.web evaluateJavaScript:jsPicture completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        DLog(@"切换本地头像");
    }];
}
@end



