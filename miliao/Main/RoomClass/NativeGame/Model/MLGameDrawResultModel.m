#import "MLGameDrawResultModel.h"
#import <MJExtension.h>

@implementation MLGameDrawResultModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"giftId": @"id"
    };
}

- (NSString *)imageUrl {
    if (self.pic && self.pic.length > 0) {
        return self.pic;
    }
    return self.image ?: @"";
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    MLGameDrawResultModel *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.giftId = self.giftId;
        copy.name = [self.name copyWithZone:zone];
        copy.pic = [self.pic copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.price = self.price;
        copy.num = self.num;
    }
    return copy;
}

#pragma mark - 有序去重合并工具方法
+ (NSArray<MLGameDrawResultModel *> *)mergeAndSortDrawGifts:(NSArray<MLGameDrawResultModel *> *)drawResultList {
    if (drawResultList == nil || drawResultList.count == 0) {
        return @[];
    }
    
    NSMutableArray *orderedIds = [NSMutableArray array];
    NSMutableDictionary<NSNumber *, MLGameDrawResultModel *> *mergedDict = [NSMutableDictionary dictionary];

    for (MLGameDrawResultModel *item in drawResultList) {
        NSNumber *itemId = @(item.giftId);
        if (mergedDict[itemId]) {
            mergedDict[itemId].num += item.num; // 已存在累加
        } else {
            [orderedIds addObject:itemId];     // 首次出现记录顺序
            mergedDict[itemId] = [item copy];  // 深拷贝
        }
    }

    NSMutableArray<MLGameDrawResultModel *> *resultArray = [NSMutableArray array];
    for (NSNumber *itemId in orderedIds) {
        MLGameDrawResultModel *mergedItem = mergedDict[itemId];
        if (mergedItem) {
            [resultArray addObject:mergedItem];
        }
    }
    return [resultArray copy];
}

@end

@implementation MLGameDrawResponseModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"list": [MLGameDrawResultModel class]
    };
}

@end
