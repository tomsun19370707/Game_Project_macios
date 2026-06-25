//
//  WebLoadVc1.h
//
//  类介绍说明：
//
//

#import "BaseVC.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebLoadVc : BaseVC
/** 网址链接地址*/
@property (nonatomic,strong)NSString *webUrl;
/** 网页html*/
@property (nonatomic,strong)NSString *webHtml;
/** 网页标题，没有的话，默认 “详情” 二字*/
@property (nonatomic,strong)NSString *titleStr;

@end

