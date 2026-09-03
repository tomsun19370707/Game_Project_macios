//
//  MLChatRoomGameCenterItem.m
//  miliao
//
//  Created by AI Assistant on 2026/9/3.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLChatRoomGameCenterItem.h"

@implementation MLChatRoomGameCenterItem

+ (instancetype)nativeItemWithName:(NSString *)name
                     localIconName:(NSString *)localIconName
                              type:(NSInteger)type
                         bagTypeId:(NSInteger)bagTypeId
                          category:(MLChatRoomGameCategory)category {
    MLChatRoomGameCenterItem *item = [[MLChatRoomGameCenterItem alloc] init];
    item.name = name;
    item.localIconName = localIconName;
    item.imageUrl = nil;
    item.isEnabled = YES;
    item.type = type;
    item.bagTypeId = bagTypeId;
    item.category = category;
    item.h5DiskId = @"0";
    item.multiplierMode = 0;
    return item;
}

+ (instancetype)remoteItemWithName:(NSString *)name
                          imageUrl:(nullable NSString *)imageUrl
                              type:(NSInteger)type
                          h5DiskId:(NSString *)h5DiskId
                    multiplierMode:(NSInteger)multiplierMode
                          category:(MLChatRoomGameCategory)category
                           rawDict:(nullable NSDictionary *)rawDict {
    MLChatRoomGameCenterItem *item = [[MLChatRoomGameCenterItem alloc] init];
    item.name = name;
    item.localIconName = nil;
    item.imageUrl = imageUrl;
    item.isEnabled = YES;
    item.type = type;
    item.bagTypeId = 0;
    item.category = category;
    item.h5DiskId = h5DiskId;
    item.multiplierMode = multiplierMode;
    item.rawDict = rawDict;
    return item;
}

@end
