//
//  MLRoomUserModel.m
//  miliao
//
//  Created by aa on 2019/6/26.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLRoomUserModel.h"

@implementation MLRoomUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userID" : @"id",
             };
}

@end
