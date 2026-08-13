//
//  MLTowerGameSixModels.m
//  miliao
//

#import "MLTowerGameSixModels.h"
#import <MJExtension/MJExtension.h>

@implementation MLCandidateItemModel

- (NSString *)value {
    if (_value && _value.length > 0) {
        return _value;
    }
    return _unit_value ?: @"0";
}

@end

@implementation MLTowerGameSixTicketTypeModel
@end

@implementation MLTowerPlayerModel
@end

@implementation MLTowerTicketModel
@end

@implementation MLTowerGiftModel
@end

@implementation MLTowerLayerInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"gifts": [MLTowerGiftModel class]
    };
}

@end

@implementation MLTowerGameSixGameDetailModel
@end

@implementation MLTowerGameSixBootstrapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"ticket_types": [MLTowerGameSixTicketTypeModel class],
        @"layers": [MLTowerLayerInfoModel class],
        @"temp_inventory": [MLCandidateItemModel class]
    };
}

@end

@implementation MLTowerGameSixFusionCandidateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"ticket_types": [MLTowerGameSixTicketTypeModel class],
        @"global_inventory": [MLCandidateItemModel class],
        @"temp_inventory": [MLCandidateItemModel class]
    };
}

@end

@implementation MLTowerGameSixRecastResultModel
@end
