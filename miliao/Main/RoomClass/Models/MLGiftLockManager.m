//
//  MLGiftLockManager.m
//  miliao
//
//  Created by AI Assistant on 2026/9/2.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLGiftLockManager.h"
#import "UserManager.h"
#import "RoomGiftModel.h"

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
        [lockedSet addObject:[NSString stringWithFormat:@"gift_%@", gid]];
    } else {
        [lockedSet removeObject:gid];
        [lockedSet removeObject:[NSString stringWithFormat:@"gift_%@", gid]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[lockedSet allObjects] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isGiftLockedWithUserId:(nullable NSString *)userId giftId:(nullable NSString *)giftId {
    if (!giftId) return NO;
    NSString *gid = [NSString stringWithFormat:@"%@", giftId];
    if (gid.length == 0) return NO;
    NSSet<NSString *> *lockedSet = [self getLockedGiftIdsWithUserId:userId];
    return [lockedSet containsObject:gid] || [lockedSet containsObject:[NSString stringWithFormat:@"gift_%@", gid]];
}

- (BOOL)isGiftLocked:(RoomGiftModel *)gift userId:(nullable NSString *)userId {
    if (!gift) return NO;
    NSSet<NSString *> *lockedSet = [self getLockedGiftIdsWithUserId:userId];
    return [self isGiftLocked:gift lockedSet:lockedSet];
}

- (BOOL)isGiftLocked:(RoomGiftModel *)gift lockedSet:(NSSet<NSString *> *)lockedSet {
    if (!gift || !lockedSet || lockedSet.count == 0) return NO;
    
    NSString *name = gift.name ? [gift.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
    if (name.length > 0) {
        if ([lockedSet containsObject:[NSString stringWithFormat:@"name_%@", name]] || [lockedSet containsObject:name]) {
            return YES;
        }
    }
    
    NSString *realGid = [gift realGiftId];
    if (realGid.length > 0 && ![realGid isEqualToString:@"0"]) {
        if ([lockedSet containsObject:[NSString stringWithFormat:@"gift_%@", realGid]] || [lockedSet containsObject:realGid]) {
            return YES;
        }
    }
    
    if (gift.giftID) {
        NSString *rawId = [NSString stringWithFormat:@"%@", gift.giftID];
        if (rawId.length > 0 && ![rawId isEqualToString:@"0"]) {
            if ([lockedSet containsObject:[NSString stringWithFormat:@"id_%@", rawId]] || [lockedSet containsObject:rawId]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)updateLockStateWithUserId:(nullable NSString *)userId gift:(RoomGiftModel *)gift isLocked:(BOOL)isLocked {
    if (!gift) return;
    NSString *key = [self storageKeyForUserId:userId];
    NSMutableSet<NSString *> *set = [[self getLockedGiftIdsWithUserId:userId] mutableCopy];
    
    NSString *name = gift.name ? [gift.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
    NSString *nameKey = name.length > 0 ? [NSString stringWithFormat:@"name_%@", name] : nil;
    
    NSString *realGid = [gift realGiftId];
    NSString *giftIdKey = (realGid.length > 0 && ![realGid isEqualToString:@"0"]) ? [NSString stringWithFormat:@"gift_%@", realGid] : nil;
    NSString *rawGiftId = (realGid.length > 0 && ![realGid isEqualToString:@"0"]) ? realGid : nil;
    
    NSString *rawId = gift.giftID ? [NSString stringWithFormat:@"%@", gift.giftID] : nil;
    NSString *idKey = (rawId.length > 0 && ![rawId isEqualToString:@"0"]) ? [NSString stringWithFormat:@"id_%@", rawId] : nil;
    
    if (isLocked) {
        if (nameKey) [set addObject:nameKey];
        if (giftIdKey) [set addObject:giftIdKey];
        if (rawGiftId) [set addObject:rawGiftId];
        if (idKey) [set addObject:idKey];
        if (rawId) [set addObject:rawId];
    } else {
        if (nameKey) [set removeObject:nameKey];
        if (name.length > 0) [set removeObject:name];
        if (giftIdKey) [set removeObject:giftIdKey];
        if (rawGiftId) [set removeObject:rawGiftId];
        if (idKey) [set removeObject:idKey];
        if (rawId) [set removeObject:rawId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[set allObjects] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
