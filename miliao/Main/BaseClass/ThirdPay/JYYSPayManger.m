//
//  JYYSPayManger.m
//  JinYiYuShi
//
//  Created by 锤子科技 on 15/7/6.
//  Copyright (c) 2015年 李东阳. All rights reserved.
//

#import "JYYSPayManger.h"
//#import "payRequsestHandler.h"
@implementation JYYSPayManger

#pragma mark - 支付宝支付

static JYYSPayManger *manger = nil;
static dispatch_once_t  oneToken;

+ (JYYSPayManger *)sharedPayManger
{
    dispatch_once(&oneToken, ^{
        manger = [[JYYSPayManger alloc]init];
    });
    return manger;
}

/** 支付宝服务端RSA2验签支付*/
- (void)ALiPayPayment:(NSString *)signString
{
    if ([NSString NotNull:signString]) {
        
        //没有安装支付宝客户端的跳到网页授权时会在这个方法里回调
        [[AlipaySDK defaultService] auth_V2WithInfo:signString fromScheme:APPLICATION_SCHEME callback:^(NSDictionary *resultDic) {
            
            DLog(@"%@",resultDic);
            
            JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
            manger.ALiAuthCallback(resultDic);
        }];
    }
}

/** 支付宝授权登录*/
- (void)aliLoginAuthSignRequest
{
//    /** 授权登录，暂时走客户端加签*/
//    [self doAPAuth];
//    return;
    
//    /** type 类型：1订单加签；2.授权加签*/
//    /** para*/
//    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
//    parameter[@"type"] = @"2";
//    ApiService *api = [ApiService new];
//    [api PostServiceRequestWithAPi:alipayAddSign parameter:parameter   showOnVC:[ObjectTool SharedSettings].currentVC isLoadingShow:YES responseSuccessObject:^(id responseObject) {
//        DLog(@"%@",responseObject);
//        
//        //你在info中/或plist中设置的appScheme
//        NSString *appScheme = AppConst(@"APPLICATION_SCHEME");
//        //authStr参数后台获取！和开发中心配置的app有关系，包含appid\name等等信息。
//        NSString *authStr = responseObject[@"data"][@"authInfo"];
//        if (authStr) {
//            
//            //没有安装支付宝客户端的跳到网页授权时会在这个方法里回调
//            [[AlipaySDK defaultService] auth_V2WithInfo:authStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                DLog(@"%@",resultDic);
//                JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
//                manger.ALiAuthCallback(resultDic);
//            }];
//        }
//    } failureT:^(NSString *msg) {
//        
//    }];
}

/** 支付宝本地验签支付*/
- (void)aliLocalPayment
{
    
}

#pragma mark -
#pragma mark  WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *rep = (PayResp *)resp ;
        if (self.WechatPaymentCallback) {
            self.WechatPaymentCallback(rep);
        }
        
    }
}
/** 微信服务端验签支付*/
- (void)WechatPayment:(NSMutableDictionary *)signDic
{
    NSMutableString *stamp  = [signDic objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [signDic objectForKey:@"appid"];
    req.partnerId           = [signDic objectForKey:@"partnerid"];
    req.prepayId            = [signDic objectForKey:@"prepayid"];
    req.nonceStr            = [signDic objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [signDic objectForKey:@"package"];
    req.sign                = [signDic objectForKey:@"sign"];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
/** 微信本地验签支付*/
- (void)wechatLocalPayment
{
    
}
/** 自带调起微信启动参数
 
 MD5签名字符串：
 appid=wx7245d2cb43a093db&device_info=APP-001&mch_id=1522977271&nonce_str=QFQYbKwzGb0rmgDp&prepay_id=wx15093611765557f4cbb8f84c2303633260&result_code=SUCCESS&return_code=SUCCESS&return_msg=OK&trade_type=APP&key=MHSHJY9876554123MHSHJY0030030020
 
 获取预支付交易标示成功！
 MD5签名字符串：
 appid=wx7245d2cb43a093db&noncestr=BF33B44B205B3B82A3D2B16556628A49&package=Sign=WXPay&partnerid=1522977271&prepayid=wx15093611765557f4cbb8f84c2303633260&timestamp=1547516171&key=MHSHJY9876554123MHSHJY0030030020
 
 第二步签名成功，sign＝52ADC5BC1157081B661942AD62577EA0
 
 {
 appid = wx7245d2cb43a093db;
 noncestr = BF33B44B205B3B82A3D2B16556628A49;
 package = "Sign=WXPay";
 partnerid = 1522977271;
 prepayid = wx15093611765557f4cbb8f84c2303633260;
 sign = 52ADC5BC1157081B661942AD62577EA0;
 timestamp = 1547516171;
 }
 
 */









#pragma mark -
#pragma mark   ==============支付宝登录，点击模拟授权行为==============
- (void)doAPAuth
{
    
}

@end








