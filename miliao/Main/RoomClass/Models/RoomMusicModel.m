//
//  RoomMusicModel.m
//  miliao
//
//  Created by aa on 2019/7/13.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomMusicModel.h"

@implementation RoomMusicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"musicID" : @"id",
             };
}

//+ (NSDictionary *)objectClassInArray{
//    return @{
//             @"yinxiao" : @"RoomMusicModel"
//             };
//}


@end
