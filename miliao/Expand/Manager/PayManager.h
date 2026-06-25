//
//  PayManager.h
//  ZYT_iOS
//
//  Created by nicz on 2018/6/27.
//  Copyright © 2018年 MHT All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MakeOrder.h"

@interface PayManager : NSObject

+ (instancetype)shareManager;
///微信支付
- (void)wechatWithOrder:(MakeOrder *)wechat;
+ (BOOL)handleOpenUrl:(NSURL *)url;
@end
