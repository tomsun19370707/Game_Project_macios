//
//  PayManager.m
//  ZYT_iOS
//
//  Created by nicz on 2018/6/27.
//  Copyright © 2018年 MHT All rights reserved.
//

#import "PayManager.h"

@implementation PayManager

+ (instancetype)shareManager {
    static PayManager *weChatPayInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            weChatPayInstance = [[PayManager alloc] init];
        });
        return weChatPayInstance;
}

///微信支付
- (void)wechatWithOrder:(MakeOrder *)wechat {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wechat.partnerid;
    request.prepayId = wechat.prepayid;
    request.package = wechat.package;
    request.nonceStr = wechat.noncestr;
//    request.timeStamp = [wechat.timestamp unsignedIntValue];
//    request.timeStamp = [wechat.timeStamp unsignedIntValue];
    request.sign = wechat.paySign;

    [WXApi sendReq:request completion:^(BOOL success) {

    }];
}


+ (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[PayManager shareManager]];
}
#pragma mark - 微信支付回调

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        /*
         enum  WXErrCode {
         WXSuccess           = 0,    < 成功
         WXErrCodeCommon     = -1,  < 普通错误类型
         WXErrCodeUserCancel = -2,   < 用户点击取消并返回
         WXErrCodeSentFail   = -3,   < 发送失败
         WXErrCodeAuthDeny   = -4,   < 授权失败
         WXErrCodeUnsupport  = -5,   < 微信不支持
         };
         */
        PayResp *response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess: {
                NSLog(@"微信回调支付成功");
//                PostNoticeObserver(KpaySuccess, nil);
            break;
            }
            case WXErrCodeCommon: {
                NSLog(@"微信回调支付异常");
                break;
            }
            case WXErrCodeUserCancel: {
                [SVProgressHUD showInfoWithStatus:@"取消支付"];
                break;
            }
            case WXErrCodeSentFail: {
                NSLog(@"微信回调发送支付信息失败");
                break;
            }
            case WXErrCodeAuthDeny: {
                NSLog(@"微信回调授权失败");
                break;
            }
            case WXErrCodeUnsupport: {
                NSLog(@"微信回调微信版本暂不支持");
                break;
            }
            default: {
                break;
            }
        }
    }
}

@end
