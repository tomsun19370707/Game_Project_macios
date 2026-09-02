//
//  MLGiftLockManager.m
//  miliao
//
//  Created by AI Assistant on 2026/9/2.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLGiftLockManager.h"
#import "UserManager.h"

static NSString *const kGiftLockPrefPrefix = @"uyu_gift_lock_pref_user_";

@implementation MLGiftLockManager

+ (instancetype)sharedManager {
    static MLGiftLockManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MLGiftLockManager alloc] init];
    });
    return instance;
}

- (NSString *)effectiveUserId:(nullable id)userId {
    if (userId) {
        NSString *uidStr = [NSString stringWithFormat:@"%@", userId];
        if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) {
            return uidStr;
        }
    }
    id currentUid = [UserManager userInfo].user_id;
    if (currentUid) {
        NSString *uidStr = [NSString stringWithFormat:@"%@", currentUid];
        if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) {
            return uidStr;
        }
    }
    return @"default";
}

- (NSString *)storageKeyForUserId:(nullable id)userId {
    return [NSString stringWithFormat:@"%@%@", kGiftLockPrefPrefix, [self effectiveUserId:userId]];
}

- (NSSet<NSString *> *)getLockedGiftIdsWithUserId:(nullable NSString *)userId {
    NSString *key = [self storageKeyForUserId:userId];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([array isKindOfClass:[NSArray class]]) {
        return [NSSet setWithArray:array];
    }
    return [NSSet set];
}

- (void)updateLockStateWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId isLocked:(BOOL)isLocked {
    if (!giftId) return;
    NSString *gid = [NSString stringWithFormat:@"%@", giftId];
    if (gid.length == 0) return;
    
    NSString *key = [self storageKeyForUserId:userId];
    NSMutableSet<NSString *> *lockedSet = [[self getLockedGiftIdsWithUserId:userId] mutableCopy];
    if (isLocked) {
        [lockedSet addObject:gid];
    } else {
        [lockedSet removeObject:gid];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[lockedSet allObjects] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isGiftLockedWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId {
    if (!giftId) return NO;
    NSString *gid = [NSString stringWithFormat:@"%@", giftId];
    if (gid.length == 0) return NO;
    NSSet<NSString *> *lockedSet = [self getLockedGiftIdsWithUserId:userId];
    return [lockedSet containsObject:gid];
}

@end
