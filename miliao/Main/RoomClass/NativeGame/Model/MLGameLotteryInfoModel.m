#import "MLGameLotteryInfoModel.h"
#import <MJExtension.h>

@implementation MLGameLotteryOptModel
@end

@implementation MLGameLotteryInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"typeId": @"id",
        @"consume_diamonds": @[@"total_cost", @"consumeDiamonds", @"consume_diamonds"],
        @"produce_diamonds": @[@"total_income", @"produceDiamonds", @"produce_diamonds"],
        @"internal_game_id": @[@"internal_game_id", @"internalGameId"],
        @"lucky": @[@"lucky", @"lucky_value", @"luckyValue"],
        @"lucky_progress_value": @[@"lucky_progress_value", @"luckyProgressValue"],
        @"lucky_progress_limit": @[@"lucky_progress_limit", @"luckyProgressLimit"],
        @"lucky_progress_percent": @[@"lucky_progress_percent", @"luckyProgressPercent"],
        @"next_guarantee_threshold": @[@"next_guarantee_threshold", @"nextGuaranteeThreshold"],
        @"next_guarantee_min_price": @[@"next_guarantee_min_price", @"nextGuaranteeMinPrice"],
        @"lucky_stage_index": @[@"lucky_stage_index", @"luckyStageIndex"],
        @"lucky_stage_count": @[@"lucky_stage_count", @"luckyStageCount"],
        @"lucky_limit": @[@"lucky_limit", @"luckyLimit", @"lucky_max", @"luckyMax"]
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
