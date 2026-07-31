//
//  MLTowerGameSixModels.m
//  miliao
//

#import "MLTowerGameSixModels.h"
#import <MJExtension/MJExtension.h>

@implementation MLCandidateItemModel
@end

@implementation MLTowerPlayerModel
@end

@implementation MLTowerTicketModel
@end

@implementation MLTowerGameSixBootstrapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"temp_inventory": [MLCandidateItemModel class]
    };
}

@end

@implementation MLTowerGameSixFusionCandidateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"global_inventory": [MLCandidateItemModel class],
        @"temp_inventory": [MLCandidateItemModel class]
    };
}

@end
