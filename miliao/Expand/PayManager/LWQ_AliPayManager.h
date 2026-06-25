//
//  LWQ_AliPayManager.h
//  XiangQing
//
//  Created by QuanQi on 2020/9/8.
//  Copyright © 2020 LWQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LWQ_AliPayManagerResultBlock)(NSDictionary *result);
//阿里支付
@interface LWQ_AliPayManager : NSObject
+ (void)alipayWithPayOrder:(NSString *)orderString andResult:(LWQ_AliPayManagerResultBlock)result;
@end

NS_ASSUME_NONNULL_END
