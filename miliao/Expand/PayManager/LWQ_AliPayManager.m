//
//  LWQ_AliPayManager.m
//  XiangQing
//
//  Created by QuanQi on 2020/9/8.
//  Copyright © 2020 LWQ. All rights reserved.
//

#import "LWQ_AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation LWQ_AliPayManager
+ (void)alipayWithPayOrder:(NSString *)orderString andResult:(LWQ_AliPayManagerResultBlock)result{
    NSString *appScheme = @"JKtaoziyuyinApp";
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}
@end
