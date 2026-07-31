//
//  MLTowerGameSixModels.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 数据模型类定义 (与后端 Response 规范1:1对齐).
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLCandidateItemModel : NSObject
@property (nonatomic, assign) long long inventory_id;
@property (nonatomic, assign) NSInteger gift_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *unit_value;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *source; // "global" 或 "temp"
@end

@interface MLTowerPlayerModel : NSObject
@property (nonatomic, assign) NSInteger current_layer;
@property (nonatomic, assign) NSInteger next_recast_layer;
@property (nonatomic, assign) NSInteger state_version;
@end

@interface MLTowerTicketModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *ticket_no;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger total_recasts;
@property (nonatomic, assign) NSInteger remaining_recasts;
@property (nonatomic, assign) NSInteger config_version;
@property (nonatomic, assign) long long created_at;
@end

@interface MLTowerGameSixBootstrapModel : NSObject
@property (nonatomic, strong) MLTowerPlayerModel *player;
@property (nonatomic, strong) MLTowerTicketModel *ticket;
@property (nonatomic, assign) NSInteger token_count;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *temp_inventory;
@end

@interface MLTowerGameSixFusionCandidateModel : NSObject
@property (nonatomic, copy) NSString *threshold_value;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *global_inventory;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *temp_inventory;
@end

NS_ASSUME_NONNULL_END
