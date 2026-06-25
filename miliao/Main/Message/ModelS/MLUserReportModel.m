//
//  MLUserReportModel.m
//  miliao
//
//  Created by feifei on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLUserReportModel.h"

@implementation MLUserReportModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"reportID" : @"id",
             };
}

@end
