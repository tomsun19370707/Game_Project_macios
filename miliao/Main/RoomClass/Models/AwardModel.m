//
//  AwardModel.m
//  miliao
//
//  Created by aa on 2019/9/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "AwardModel.h"

@implementation AwardModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"giftID" : @"id",
             };
}
@end
