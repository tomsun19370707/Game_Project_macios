//
//  PackModel.m
//  miliao
//
//  Created by aa on 2019/9/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "PackModel.h"

@implementation PackModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"target_id":@"id"};
}
- (NSString *)select
{
    if (!_select) {
        _select = @"0";
    }
    return _select;
}
@end
