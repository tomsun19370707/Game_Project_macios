//
//  MLUnifiedExchangeItem.h
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLUnifiedExchangeItem : NSObject

@property (nonatomic, assign) NSInteger itemId;       // 背包记录ID 或 商城ID
@property (nonatomic, assign) NSInteger giftId;       // 礼物真实ID (必须传此ID给兑换接口)
@property (nonatomic, copy) NSString *name;           // 礼物名称
@property (nonatomic, copy) NSString *image;          // 礼物图标URL
@property (nonatomic, assign) NSInteger ownedNum;     // 拥有数量
@property (nonatomic, assign) double unitRatio;       // 单个礼物兑换黑曜石比例
@property (nonatomic, assign) NSInteger prizeCoin;    // 元宝消耗
@property (nonatomic, assign) NSInteger ratioCoin;    // 黑曜石消耗
@property (nonatomic, assign) BOOL isBackpackGift;    // 是否来自背包
@property (nonatomic, assign) BOOL isSelected;        // 是否选中

@property (nonatomic, strong, nullable) NSDictionary *rawDict;

+ (instancetype)itemFromGiftDictionary:(NSDictionary *)dict;
+ (instancetype)itemFromMallDictionary:(NSDictionary *)dict ownedCount:(NSInteger)ownedCount;

/// 统一大数格式化显示 (>=1万用"万", >=1亿用"亿", 去除多余的0)
+ (NSString *)formatLargeNumber:(double)num;

@end

NS_ASSUME_NONNULL_END
