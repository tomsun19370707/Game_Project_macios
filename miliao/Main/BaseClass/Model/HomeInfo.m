//
//  CityInfo.m
//  ChinaFuel
//
//  Created by 李东阳 on 2019/5/9.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "HomeInfo.h"

@implementation HomeInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [HomeInfoModel class],
             };
}
@end

@implementation HomeInfoModel

@end

@implementation LunboInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [LunboInfoModel class],
             };
}
@end

@implementation LunboInfoModel

@end

@implementation GoodListInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [GoodListInfoModel class],
             };
}
@end

@implementation GoodListInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"shop" : [ShopInfoModel class],
             @"ecCategories" : [GoodListInfoModel class],
             };
}

@end

@implementation GoodDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [GoodListInfoModel class],
             };
}

@end

@implementation GoodCateInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [GoodListInfoModel class],
             };
}

@end

@implementation NewsLookModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [GoodListInfoModel class],
             };
}

@end

@implementation ShopInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [ShopInfoModel class],
             };
}

@end

@implementation ShopInfoModel


@end

@implementation ShopInfoList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [ShopInfoModel class],
             };
}

@end

@implementation GoodStanderModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"template"]) {
        [self setValue:value forKey:@"templateUrl"];
    }
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }
}

@end

/** 商品评价列表*/
@implementation GoodCommet

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [GoodCommentModel class],
             };
}

@end

@implementation GoodCommentModel



@end

/** 优惠券列表*/
@implementation CouponInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [CouponInfoModel class],
             };
}

@end

@implementation CouponInfoModel



@end
