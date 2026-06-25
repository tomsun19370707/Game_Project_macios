//
//  MakeOrder.m
//  ZYT_iOS
//
//  Created by nicz on 2018/6/26.
//  Copyright © 2018年 MHT All rights reserved.
//

#import "MakeOrder.h"

@implementation MakeOrder

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"oid": @"order_id",
             @"num": @"order_number",
             @"endTime": @"stop_time"};
}

@end
