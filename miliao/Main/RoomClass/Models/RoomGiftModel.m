//
//  RoomGiftModel.m
//  miliao
//
//  Created by aa on 2019/7/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomGiftModel.h"

@implementation RoomGiftModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"giftID" : @"id"
    };
}

- (NSString *)realGiftId {
    NSString *gid = nil;
    if (self.gift_id) {
        gid = [NSString stringWithFormat:@"%@", self.gift_id];
    }
    if (gid.length > 0 && ![gid isEqualToString:@"0"]) {
        return gid;
    }
    if (self.giftID) {
        return [NSString stringWithFormat:@"%@", self.giftID];
    }
    return @"";
}

- (BOOL)isLocked {
    return _is_locked;
}

- (void)setIsLocked:(BOOL)isLocked {
    _is_locked = isLocked;
}

@end
