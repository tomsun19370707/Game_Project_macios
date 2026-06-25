//
//  BaseModelDy.m
//  doctorUser
//
//  Created by 李东阳 on 2019/4/17.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "BaseModelDy.h"

@implementation BaseModelDy
#pragma mark --
#pragma mark --- 声明自定义类参数类型
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
    /**
     声明sex字段是sexDic下的sex
     @"sex":@"sexDic.sex"
     */
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"page" : [PageModel class],
             };
}

//#pragma mark --
//#pragma mark --- 当 JSON 转为 Model 完成后，该方法会被调用。
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
//    return YES;
//}
//
//#pragma mark --
//#pragma mark --- 当 Model 转为 JSON 完成后，该方法会被调用。
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    return YES;
//}
@end


@implementation PageModel
@end


@implementation queryBeanModel
@end
