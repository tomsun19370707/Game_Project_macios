//
//  EMO_WebViewController.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/11/19.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "EMO_WebViewController.h"
#import <WebKit/WebKit.h>

@interface EMO_WebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) NSString *notify_url;
@property (nonatomic,strong) NSString *return_url;
@property (nonatomic,strong) WKWebView *webView;

@end

@implementation EMO_WebViewController


-(void)backClick{
    if (self.pushType==1) {
       [self dismissViewControllerAnimated:YES completion:nil];
   }else{
       [self.navigationController popViewControllerAnimated:YES];
   }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
//    WeakSelf;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=self.titleType;
    self.titleLabel.font=KFont(18);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    
   //配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
       configuration.userContentController = [WKUserContentController new];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 16;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
       //配置js调用统一参数
       [configuration.userContentController addScriptMessageHandler:self name:@"qqlogin"];
       [configuration.userContentController addScriptMessageHandler:self name:@"wxlogin"];

    
//      WKWebView *webView = [[WKWebView alloc] init];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
     webView.frame=CGRectMake(0, ZJTopNavH+ZJStatusBarH, kWidth, kHeight-ZJTopNavH-ZJStatusBarH);
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.showsHorizontalScrollIndicator=NO;
      webView.navigationDelegate = self;
      webView.UIDelegate = self;
    
    if (![self.strUrl hasPrefix:@"http"]) {
        [webView loadHTMLString:self.strUrl baseURL:nil];
    }else{
           NSURL *payURL = [NSURL URLWithString:self.strUrl];
              NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:payURL];
              [webView loadRequest:request];
    }
//     [webView loadFileURL:[[NSBundle mainBundle] URLForResource:@"text" withExtension:@"html"] allowingReadAccessToURL:[[NSBundle mainBundle] bundleURL]];
     [self.view addSubview:webView];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    if (![self.strType isEqualToString:@"H5"]) {
//        //修改字体大小 300%
           [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"completionHandler:nil];
//    }
   
    
//    //修改字体颜色  #9098b8
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'"completionHandler:nil];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   NSLog(@"拦截urlscheme==%@", [navigationAction.request.URL scheme]);
   NSLog(@"拦截url==%@", [navigationAction.request.URL absoluteString]);

    decisionHandler(WKNavigationActionPolicyAllow);
}
- (NSString *)urlEncodeStr:(NSString *)input {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}
- (NSString *)decoderUrlEncodeStr: (NSString *) input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
    NSLog(@"进程终止");
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSLog(@"%@", challenge.protectionSpace.serverTrust);
    NSURLCredential *trustCredential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, trustCredential);
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (!frameInfo.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    NSLog(@"%@", webView.URL);
    NSLog(@"%@", navigationAction.targetFrame);
    return nil;
}



#pragma mark - WKUIDelegate
// 在JS端调用alert函数alert(content)时，会触发此代理方法，通过message可以拿到JS端所传的数据，在iOS端得到结果后，需要回调JS，通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"JS调用alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// JS端调用confirm函数时，会触发此方法，通过message可以拿到JS端所传的数据，在iOS端显示原生alert得到YES/NO后，通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

//JS端调用prompt函数时，会触发此方法，要求输入一段文本，在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
  
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKScriptMessageHandler
//接收从js传给oc的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    if ([message.name isEqualToString:@"wxlogin"]) {
//        self.messagebody=[NSString stringWithFormat:@"%@",message.body];
//        if ([WXApi isWXAppInstalled]) {
//            SendAuthReq *req=[[SendAuthReq alloc]init];
//            req.scope=@"snsapi_userinfo";
//            req.state=@"12WanAPP";
//
//            [WXApi sendReq:req completion:^(BOOL success) {
//                NSLog(@"%d",success);
//
//            }];
//
//        }else{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:actionConfirm];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//
//    }
    
    NSLog(@"%@====%@=====%@",message,message.name,message.body);
    
}
//
////oc数据传给js
//- (void)transterClick {
//
//    NSString * paramString = self.OCView.fieldView.text;
//    //transferPrama()是JS的语言
//    NSString * jsStr = [NSString stringWithFormat:@"transferPrama('%@')",paramString];
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"result=%@  error=%@",result, error);
//    }];
//}


-(void)wechatDidLoginNotification:(NSNotification *)content{
    
    NSLog(@"%@",content.userInfo[@"code"]);
//    NSString *urlStr=[NSString string];
//    if ([self.messagebody containsString:@"?"]) {
//        urlStr=[NSString stringWithFormat:@"%@&access_token=%@",self.messagebody,content.userInfo[@"code"]];
//    }else{
//        urlStr=[NSString stringWithFormat:@"%@?access_token=%@",self.messagebody,content.userInfo[@"code"]];
//    }
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//     [request setValue:@"a1.company.com://wxpaycallback/" forHTTPHeaderField:@"Referer"];
//    [self.webView loadRequest:request];
//

  
}


//json格式字符串转字典

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"qqlogin"];
     [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"wxlogin"];
}


@end
