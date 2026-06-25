//
//  EMO_FriendsModel.m
//  miliao
//
//  Created by aa on 2019/7/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_FriendsModel.h"

@implementation EMO_FriendsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"friendID" : @"id"
             };
}

-(void)setAvatar:(NSString *)avatar{
    if ([avatar hasPrefix:@"http"]) {
        _avatar = avatar;
    }else{
        _avatar = [NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,avatar];
    }
}

@end
