//
//  MLChatRoomGameCenterItem.h
//  miliao
//
//  Created by AI Assistant on 2026/9/3.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MLChatRoomGameCategory) {
    MLChatRoomGameCategoryEntertainment = 1, // 娱乐 (原生玩法/赛跑/三色福袋)
    MLChatRoomGameCategoryFun = 2            // 趣味 (H5抽奖盘/倍率盘)
};

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomGameCenterItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *localIconName;
@property (nonatomic, copy, nullable) NSString *imageUrl; // 远程封面图
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) NSInteger type; // 1:寻梦, 2:神木, 3:星辰, 4:福袋, 5:星球, 6:珍宝塔, 7:赛跑, 8:H5抽奖, 9:倍率盘
@property (nonatomic, assign) NSInteger bagTypeId; // 8:青玉, 9:碧海, 10:鎏金 (仅福袋)
@property (nonatomic, assign) MLChatRoomGameCategory category;
@property (nonatomic, copy, nullable) NSString *h5DiskId; // H5 盘或倍率盘 ID
@property (nonatomic, assign) NSInteger multiplierMode; // 倍率盘 mode
@property (nonatomic, strong, nullable) NSDictionary *rawDict;

+ (instancetype)nativeItemWithName:(NSString *)name
                     localIconName:(NSString *)localIconName
                              type:(NSInteger)type
                         bagTypeId:(NSInteger)bagTypeId
                          category:(MLChatRoomGameCategory)category;

+ (instancetype)remoteItemWithName:(NSString *)name
                          imageUrl:(nullable NSString *)imageUrl
                              type:(NSInteger)type
                          h5DiskId:(NSString *)h5DiskId
                    multiplierMode:(NSInteger)multiplierMode
                          category:(MLChatRoomGameCategory)category
                           rawDict:(nullable NSDictionary *)rawDict;

@end

NS_ASSUME_NONNULL_END
