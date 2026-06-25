//
//  MEMHotChatModel.m
//
//  类介绍说明：
//
//

#import "MEMHotChatModel.h"

@implementation MEMHotChatModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [MEMHotChatInfoModel class] };
}

@end

@implementation MEMHotChatDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"data" : [MEMHotChatInfoModel class]  , @"list" : [MEMHotChatInfoModel class] , @"goods" : [MEMHotChatInfoModel class] , @"address" : [MEMHotChatInfoModel class] , @"goodsGroupRecord" : [NSDictionary class]};//, @"page" : [MEMHotChatInfoModel class]
}

@end


@implementation MEMHotChatInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"projectCategoryList" : [MEMHotChatInfoModel class] , @"programQuoteList" : [MEMHotChatInfoModel class] , @"appUserCoupons" : [MEMHotChatInfoModel class]
             };
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionStr"];
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",@"Friend" : @"friend" , @"descriptionStr" : @"description"};
    /**
     声明sex字段是sexDic下的sex
     @"sex":@"sexDic.sex"
     */
}


@end
