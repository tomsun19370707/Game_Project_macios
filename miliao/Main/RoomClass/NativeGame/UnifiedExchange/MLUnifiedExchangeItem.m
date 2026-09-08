//
//  MLUnifiedExchangeItem.m
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import "MLUnifiedExchangeItem.h"

@implementation MLUnifiedExchangeItem

+ (instancetype)itemFromGiftDictionary:(NSDictionary *)dict {
    MLUnifiedExchangeItem *item = [[MLUnifiedExchangeItem alloc] init];
    item.rawDict = dict;
    item.isBackpackGift = YES;
    
    item.itemId = [dict[@"id"] integerValue];
    // gift_id 兼容多种键名
    if (dict[@"gift_id"] != nil) {
        item.giftId = [dict[@"gift_id"] integerValue];
    } else if (dict[@"giftId"] != nil) {
        item.giftId = [dict[@"giftId"] integerValue];
    } else {
        item.giftId = item.itemId;
    }
    
    item.name = dict[@"name"] ? [NSString stringWithFormat:@"%@", dict[@"name"]] : @"";
    item.image = dict[@"image"] ? [NSString stringWithFormat:@"%@", dict[@"image"]] : @"";
    
    // 拥有数量
    if (dict[@"num"] != nil) {
        item.ownedNum = [dict[@"num"] integerValue];
    } else if (dict[@"nums"] != nil) {
        item.ownedNum = [dict[@"nums"] integerValue];
    } else {
        item.ownedNum = 0;
    }
    
    // 优先解析礼物单价 price 作为兑换黑曜石比例 (单件背包礼物兑换黑曜石 = 礼物单价 price)
    double priceVal = 0;
    id priceObj = dict[@"price"];
    if (priceObj) {
        priceVal = [priceObj doubleValue];
    }
    if (priceVal > 0) {
        item.unitRatio = priceVal;
    } else {
        // 兜底：若 price 为空或 0，尝试 exchange_num 与 num
        double totalExchange = 0;
        id exchangeNumObj = dict[@"exchange_num"];
        if (exchangeNumObj) {
            totalExchange = [exchangeNumObj doubleValue];
        }
        if (item.ownedNum > 0 && totalExchange > 0) {
            item.unitRatio = totalExchange / item.ownedNum;
        } else {
            item.unitRatio = 1.0;
        }
    }
    if (item.unitRatio <= 0) {
        item.unitRatio = 1.0;
    }
    
    return item;
}

+ (instancetype)itemFromMallDictionary:(NSDictionary *)dict ownedCount:(NSInteger)ownedCount {
    MLUnifiedExchangeItem *item = [[MLUnifiedExchangeItem alloc] init];
    item.rawDict = dict;
    item.isBackpackGift = NO;
    
    item.itemId = [dict[@"id"] integerValue];
    item.giftId = [dict[@"id"] integerValue];
    item.name = dict[@"name"] ? [NSString stringWithFormat:@"%@", dict[@"name"]] : @"";
    item.image = dict[@"image"] ? [NSString stringWithFormat:@"%@", dict[@"image"]] : @"";
    item.ownedNum = ownedCount;
    
    NSInteger priceCoin = 0;
    if (dict[@"prize_coin"] != nil) {
        priceCoin = [dict[@"prize_coin"] integerValue];
    } else if (dict[@"prizeCoin"] != nil) {
        priceCoin = [dict[@"prizeCoin"] integerValue];
    } else if (dict[@"coin"] != nil) {
        priceCoin = [dict[@"coin"] integerValue];
    }
    item.prizeCoin = priceCoin;
    
    NSInteger ratioCoin = 0;
    if (dict[@"ratio_coin"] != nil) {
        ratioCoin = [dict[@"ratio_coin"] integerValue];
    } else if (dict[@"ratioCoin"] != nil) {
        ratioCoin = [dict[@"ratioCoin"] integerValue];
    }
    item.ratioCoin = ratioCoin;
    
    item.unitRatio = item.ratioCoin > 0 ? (double)item.ratioCoin : 1.0;
    
    return item;
}

+ (NSString *)formatDecimal:(double)val {
    NSString *str = [NSString stringWithFormat:@"%.2f", val];
    if ([str containsString:@"."]) {
        while ([str hasSuffix:@"0"]) {
            str = [str substringToIndex:str.length - 1];
        }
        if ([str hasSuffix:@"."]) {
            str = [str substringToIndex:str.length - 1];
        }
    }
    return str;
}

+ (NSString *)formatLargeNumber:(double)num {
    if (num <= 0) {
        return @"0";
    }
    if (num >= 1000000000000.0) { // 1万亿
        double v = num / 1000000000000.0;
        return [NSString stringWithFormat:@"%@万亿", [self formatDecimal:v]];
    } else if (num >= 100000000.0) { // 1亿
        double v = num / 100000000.0;
        return [NSString stringWithFormat:@"%@亿", [self formatDecimal:v]];
    } else if (num >= 10000.0) { // 1万
        double v = num / 10000.0;
        return [NSString stringWithFormat:@"%@万", [self formatDecimal:v]];
    } else {
        if (num == (long long)num) {
            return [NSString stringWithFormat:@"%lld", (long long)num];
        }
        return [self formatDecimal:num];
    }
}

@end
