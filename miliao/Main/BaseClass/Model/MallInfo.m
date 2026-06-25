//
//  MallInfo.m
//  enjoyfun
//
//  Created by 李东阳 on 2019/10/23.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "MallInfo.h"

@implementation MallInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [CarInfo class],
             };
}
@end

@implementation CarInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"goods" : [CarInfoGood class],
             };
}

@end

@implementation CarInfoGood


@end

@implementation CarValidGood

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [CarInfoGood class],
             };
}


@end

@implementation AddressInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [AddressInfoModel class],
             };
}

@end

@implementation AddressInfoModel



@end

@implementation AddressInfoSave



@end

@implementation OrderInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [OrderInfoModel class],
             };
}

@end

@implementation OrderInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cusEndTime" : @"endTime",
             @"ID" : @"id",
             };
    /**
     声明sex字段是sexDic下的sex
     @"sex":@"sexDic.sex"
     */
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"orderGoodList" : [OrderInfoModel class],
             @"orderGoods" : [OrderInfoModel class],
             @"farmCuts" : [CouponInfoModel class],
             @"userCoupons" : [CouponInfoModel class],
             };
}

@end

@implementation OrderInfoLook



@end

@implementation OrderInfoPreSubmitData



@end

@implementation OrderInfoPreSubmit

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"details" : [OrderInfoModel class],
             };
}

@end


