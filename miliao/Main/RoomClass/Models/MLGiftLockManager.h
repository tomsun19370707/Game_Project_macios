//
//  MLGiftLockManager.h
//  miliao
//
//  Created by AI Assistant on 2026/9/2.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLGiftLockManager : NSObject

+ (instancetype)sharedManager;

/**
 获取指定用户已锁定的礼物 ID 集合
 */
- (NSSet<NSString *> *)getLockedGiftIdsWithUserId:(nullable NSString *)userId;

/**
 更新指定用户单个礼物的锁定状态
 */
- (void)updateLockStateWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId isLocked:(BOOL)isLocked;

/**
 判断指定用户某个礼物是否锁定
 */
- (BOOL)isGiftLockedWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId;

@end

NS_ASSUME_NONNULL_END
