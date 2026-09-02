//
//  RoomGiftModel.m
//  miliao
//
//  Created by aa on 2019/7/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomGiftModel.h"
#import "MLGiftLockManager.h"

@implementation RoomGiftModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"giftID" : @"id"
    };
}

- (NSString *)realGiftId {
    NSString *gid = nil;
    if (self.gift_id) {
        gid = [NSString stringWithFormat:@"%@", self.gift_id];
    }
    if (gid.length > 0 && ![gid isEqualToString:@"0"]) {
        return gid;
    }
    if (self.giftID) {
        return [NSString stringWithFormat:@"%@", self.giftID];
    }
    return @"";
}

- (BOOL)isLocked {
    return _is_locked;
}

- (void)setIsLocked:(BOOL)isLocked {
    _is_locked = isLocked;
}

+ (NSMutableArray<RoomGiftModel *> *)mergeBackpackGiftList:(NSArray<RoomGiftModel *> *)rawList userId:(nullable NSString *)userId {
    if (!rawList || rawList.count == 0) {
        return [NSMutableArray array];
    }
    
    NSMutableDictionary<NSString *, RoomGiftModel *> *mergedDict = [NSMutableDictionary dictionary];
    NSMutableArray<NSString *> *orderedKeys = [NSMutableArray array];
    NSSet<NSString *> *lockedIds = [[MLGiftLockManager sharedManager] getLockedGiftIdsWithUserId:userId];
    
    for (RoomGiftModel *item in rawList) {
        if (![item isKindOfClass:[RoomGiftModel class]]) continue;
        
        // ⭐️ 三级主键优先级策略 (3-Tier Priority Strategy)
        NSString *mergeKey = nil;
        NSString *trimmedName = item.name ? [item.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        NSString *realGid = [item realGiftId];
        
        if (realGid.length > 0 && ![realGid isEqualToString:@"0"]) {
            // 1. 物理主键优先：标准礼物 ID 唯一分组
            mergeKey = [NSString stringWithFormat:@"gift_%@", realGid];
        } else if (trimmedName.length > 0) {
            // 2. 文本降级兜底：缺失 gift_id 时按礼物名称容错聚合
            mergeKey = [NSString stringWithFormat:@"name_%@", trimmedName];
        } else if (item.giftID) {
            // 3. 流水行主键保底
            mergeKey = [NSString stringWithFormat:@"id_%@", item.giftID];
        } else {
            mergeKey = [NSString stringWithFormat:@"item_%p", item];
        }
        
        RoomGiftModel *existing = mergedDict[mergeKey];
        if (existing) {
            // ⭐️ 累加同款礼物数量
            long long existingNum = [NSString stringWithFormat:@"%@", existing.num].longLongValue;
            long long itemNum = [NSString stringWithFormat:@"%@", item.num].longLongValue;
            if (itemNum <= 0) itemNum = 1;
            if (existingNum <= 0) existingNum = 1;
            existing.num = [NSString stringWithFormat:@"%lld", existingNum + itemNum];
            
            // 补齐有效 gift_id
            NSString *exGid = [existing realGiftId];
            if ((exGid.length == 0 || [exGid isEqualToString:@"0"]) && (realGid.length > 0 && ![realGid isEqualToString:@"0"])) {
                existing.gift_id = realGid;
            }
        } else {
            // 初始数量兜底
            long long itemNum = [NSString stringWithFormat:@"%@", item.num].longLongValue;
            if (itemNum <= 0) item.num = @"1";
            
            // 判定并赋值锁定状态
            item.isLocked = [[MLGiftLockManager sharedManager] isGiftLocked:item lockedSet:lockedIds];
            mergedDict[mergeKey] = item;
            [orderedKeys addObject:mergeKey];
        }
    }
    
    // 保持服务端下发的首现顺序
    NSMutableArray<RoomGiftModel *> *result = [NSMutableArray arrayWithCapacity:orderedKeys.count];
    for (NSString *key in orderedKeys) {
        RoomGiftModel *model = mergedDict[key];
        if (model) {
            [result addObject:model];
        }
    }
    return result;
}

@end
