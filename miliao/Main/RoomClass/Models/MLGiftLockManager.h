//
//  MLGiftLockManager.h
//  miliao
//
//  Created by AI Assistant on 2026/9/2.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomGiftModel;

@interface MLGiftLockManager : NSObject

+ (instancetype)sharedManager;

/**
 获取指定用户已锁定的礼物标识集合
 */
- (NSSet<NSString *> *)getLockedGiftIdsWithUserId:(nullable NSString *)userId;

/**
 更新指定用户单个礼物的锁定状态 (ID维)
 */
- (void)updateLockStateWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId isLocked:(BOOL)isLocked;

/**
 判断指定用户某个礼物是否锁定 (ID维)
 */
- (BOOL)isGiftLockedWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId;

/**
 判断指定用户某个礼物模型是否锁定 (支持 name, gift_id, id 多维匹配)
 */
- (BOOL)isGiftLocked:(RoomGiftModel *)gift userId:(nullable NSString *)userId;
- (BOOL)isGiftLocked:(RoomGiftModel *)gift lockedSet:(NSSet<NSString *> *)lockedSet;

/**
 更新指定用户礼物模型的锁定状态 (多维写入/移除)
 */
- (void)updateLockStateWithUserId:(nullable NSString *)userId gift:(RoomGiftModel *)gift isLocked:(BOOL)isLocked;

@end

NS_ASSUME_NONNULL_END
