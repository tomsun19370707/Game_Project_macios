//
//  XTWKWebViewController.h
//  xitu
//
//  Created by Gavin on 2019/5/30.
//  Copyright © 2019 xitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
@class WKProcessPool;
@interface SRWKWebViewController : UIViewController
@property (nonatomic, strong)WKWebView *wkWebView;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, copy)NSString *mainURL;
@property (nonatomic, readonly) NSString *currentUrl;
@property (nonatomic, assign, getter=isIgnoreWebTitle)BOOL ignoreWebTitle;
@property (nonatomic, assign, getter=isDecode)BOOL decode;
//返回
- (void)goBack;
//关闭浏览器
- (void)close;
//清理缓存
- (void)clearWbCache;

- (void)webviewEndLoad:(nullable WKWebView *)webView;

- (void)showInView:(UIView *)superView ;

/**
 添加原生方法给H5调用

 @param target 方法接收者
 @param selector 方法
 @param name H5调用该方法的关键字
 */
- (void)addScriptMessageHandlerWithTarget:(id)target selector:(SEL)selector name:(NSString *)name;

- (void)evaluateJavaScript:(NSString *)script completionHandler:(void (^ _Nullable)(_Nullable id object, NSError * _Nullable error))completionHandler;

- (void)configCookie;
- (void)analyseWebviewParams:(WKWebView *)webview;

- (void)setWebViewContentInset:(UIEdgeInsets)contentInset;
- (void)setNavTitleColor:(UIColor *)titleColor;
- (void)updateBackItemImage:(UIImage *)image;
- (NSString *)nonullWebTitle;

@end


@interface WKProcessPoolMannager : NSObject
@property (nonatomic, strong, readonly)WKProcessPool *pool;
+ (WKProcessPoolMannager *)shared;
@end
NS_ASSUME_NONNULL_END
