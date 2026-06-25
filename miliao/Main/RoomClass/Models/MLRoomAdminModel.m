//
//  MLRoomAdminModel.m
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLRoomAdminModel.h"

@implementation MLRoomAdminModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"microphoneID" : @"id",
             };
}

@end
