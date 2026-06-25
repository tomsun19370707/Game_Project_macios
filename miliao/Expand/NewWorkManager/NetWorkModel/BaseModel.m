//
//  BaseModel.m
//  oxwall
//
//  Created by ChuanQi on 2019/7/29.
//  Copyright © 2019 ChuanQi. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
    
    };
}
@end

@implementation BaseMsgModel

@end

@implementation RootModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
    };
}
@end
