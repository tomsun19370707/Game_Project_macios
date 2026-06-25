//
//  JYYSPayManger.h
//  JinYiYuShi
//
//  Created by 锤子科技 on 15/7/6.
//  Copyright (c) 2015年 李东阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** 支付宝支付*/
#import <AlipaySDK/AlipaySDK.h>
///** 支付宝授权登录用*/
//#import "APAuthInfo.h"
//#import "APOrderInfo.h"
//#import "APRSASigner.h"
/** 微信支付*/
#import "WXApi.h"

@interface JYYSPayManger : NSObject<WXApiDelegate>
/*****************************走本地验签支付时候，必传************************************/
/** 支付金额*/
@property (nonatomic,strong) NSString *payMoney;
/** 订单编号，unnicode*/
@property (nonatomic,strong) NSString *unionCode;
/***************************** end ************************************/

+ (JYYSPayManger *)sharedPayManger;

/** 支付宝服务端RSA2验签支付*/
- (void)ALiPayPayment:(NSString *)signString;
/** 支付宝支付结果*/
@property (nonatomic,copy) void (^ALiPayPaymentCallback)(NSDictionary *resultDic);


/** 支付宝授权登录*/
- (void)aliLoginAuthSignRequest;
/** 授权登录回调结果*/
@property (nonatomic,copy) void (^ALiAuthCallback)(NSDictionary *resultDic);

/** 微信服务端验签支付*/
- (void)WechatPayment:(NSMutableDictionary *)signDic;
/** 微信支付结果*/
@property (nonatomic,copy) void (^WechatPaymentCallback)(PayResp *resp);
/** 微信本地验签支付*/
- (void)wechatLocalPayment;
@end




