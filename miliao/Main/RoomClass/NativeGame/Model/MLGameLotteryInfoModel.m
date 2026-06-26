#import "MLGameLotteryInfoModel.h"
#import <MJExtension.h>

@implementation MLGameLotteryOptModel
@end

@implementation MLGameLotteryInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"typeId": @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"coin_cost_opt": [MLGameLotteryOptModel class]
    };
}

- (NSString *)imageUrl {
    if (self.pic && self.pic.length > 0) {
        return self.pic;
    }
    return self.image ?: @"";
}

@end

@implementation MLGameUserMoneyModel
@end
