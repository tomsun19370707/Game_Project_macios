//
//  MLTowerGameSixModels.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 数据模型类定义 (与后端 Response 规范1:1对齐).
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLCandidateItemModel : NSObject
@property (nonatomic, assign) NSInteger position; // 1~5
@property (nonatomic, assign) long long inventory_id;
@property (nonatomic, assign) NSInteger gift_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *unit_value;
@property (nonatomic, copy, nullable) NSString *unit_ratio_coin_value;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *source; // "global" 或 "temp"
@end

typedef MLCandidateItemModel MLTowerGameSixTempInventoryModel;

@interface MLTowerPlayerModel : NSObject
@property (nonatomic, assign) NSInteger current_layer;
@property (nonatomic, assign) NSInteger next_recast_layer;
@property (nonatomic, assign) NSInteger state_version;
@end

@interface MLTowerGameSixTicketTypeModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger ticket_layer;
@property (nonatomic, assign) NSInteger start_layer;
@property (nonatomic, copy) NSString *ticket_value;
@property (nonatomic, copy, nullable) NSString *required_ratio_coin;
@property (nonatomic, copy, nullable) NSString *ratio_coin_price;
@property (nonatomic, copy, nullable) NSString *exchange_currency;
@property (nonatomic, copy, nullable) NSString *exchange_currency_name;
@property (nonatomic, assign) NSInteger total_recasts;
@property (nonatomic, assign) BOOL is_from_backend;
@end

@interface MLTowerTicketModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *ticket_no;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy, nullable) NSString *phase; // recasting: 挑战中; awaiting_claim: 待领取
@property (nonatomic, assign) NSInteger ticket_type_id;
@property (nonatomic, copy) NSString *ticket_value;
@property (nonatomic, copy, nullable) NSString *required_ratio_coin;
@property (nonatomic, copy, nullable) NSString *ratio_coin_price;
@property (nonatomic, assign) NSInteger ticket_layer;
@property (nonatomic, assign) NSInteger start_layer;
@property (nonatomic, assign) NSInteger total_recasts;
@property (nonatomic, assign) NSInteger remaining_recasts;
@property (nonatomic, assign) NSInteger recast_terminated;
@property (nonatomic, assign) NSInteger config_version;
@property (nonatomic, assign) long long created_at;
@end

@interface MLTowerGiftModel : NSObject
@property (nonatomic, assign) NSInteger position; // 1~5
@property (nonatomic, assign) NSInteger gift_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy, nullable) NSString *ratio_coin_value;
@property (nonatomic, copy, nullable) NSString *value_currency;
@property (nonatomic, copy, nullable) NSString *value_currency_name;
@property (nonatomic, assign) NSInteger advance_step; // 0, 1, 2
@property (nonatomic, copy, nullable) NSString *probability_percent; // 下落概率百分比 (如 "50.0000", "2.0000")
@property (nonatomic, assign) long long probability_weight;
@end

@interface MLTowerLayerInfoModel : NSObject
@property (nonatomic, assign) NSInteger layer; // 1~7
@property (nonatomic, strong) NSArray<MLTowerGiftModel *> *gifts;
@end

@interface MLTowerGameSixGameDetailModel : NSObject
@property (nonatomic, copy) NSString *rule_content;
@end

@interface MLTowerGameSixCurrentRewardModel : NSObject
@property (nonatomic, assign) NSInteger ticket_id;
@property (nonatomic, assign) long long draw_id;
@property (nonatomic, assign) NSInteger gift_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy, nullable) NSString *value_currency;
@property (nonatomic, copy, nullable) NSString *value_currency_name;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger to_layer;
@end

@interface MLTowerGameSixBootstrapModel : NSObject
@property (nonatomic, strong) MLTowerPlayerModel *player;
@property (nonatomic, strong) MLTowerTicketModel *ticket;
@property (nonatomic, strong) MLTowerGameSixGameDetailModel *game;
@property (nonatomic, assign) NSInteger token_count;
@property (nonatomic, copy, nullable) NSString *reward_mode; // "single_claim"
@property (nonatomic, assign) NSInteger can_recast;     // 0: 禁止继续重铸; 1: 允许继续重铸
@property (nonatomic, assign) NSInteger can_claim;      // 0: 不可领取; 1: 允许获取当前礼物
@property (nonatomic, strong, nullable) MLTowerGameSixCurrentRewardModel *current_reward;
@property (nonatomic, strong) NSArray<MLTowerGameSixTicketTypeModel *> *ticket_types;
@property (nonatomic, strong) NSArray<MLTowerLayerInfoModel *> *layers;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *temp_inventory;
@end

@interface MLTowerGameSixFusionCandidateModel : NSObject
@property (nonatomic, copy) NSString *threshold_value;
@property (nonatomic, strong) NSArray<MLTowerGameSixTicketTypeModel *> *ticket_types;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *global_inventory;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *temp_inventory;
@end

@interface MLTowerGameSixRecastResultModel : NSObject
@property (nonatomic, copy, nullable) NSString *request_id;
@property (nonatomic, assign) NSInteger ticket_id;
@property (nonatomic, assign) long long draw_id;
@property (nonatomic, assign) NSInteger from_layer;
@property (nonatomic, assign) NSInteger position; // 1~5
@property (nonatomic, assign) NSInteger advance_step;
@property (nonatomic, assign) NSInteger to_layer;
@property (nonatomic, assign) NSInteger next_recast_layer;
@property (nonatomic, assign) long long inventory_id;
@property (nonatomic, strong) MLCandidateItemModel *gift;
@property (nonatomic, assign) NSInteger token_count;
@property (nonatomic, copy, nullable) NSString *ticket_status;
@property (nonatomic, assign) NSInteger remaining_recasts;
@property (nonatomic, assign) NSInteger state_version;
@property (nonatomic, assign) NSInteger can_recast;     // 0: 禁止继续抽; 1: 可在当前/高层继续抽
@property (nonatomic, assign) NSInteger can_claim;      // 0: 不可领取; 1: 允许获取当前礼物
@property (nonatomic, copy, nullable) NSString *reward_status; // "pending"
@property (nonatomic, copy, nullable) NSString *reward_mode;   // "single_claim"
@property (nonatomic, copy, nullable) NSString *recast_stop_reason; // "low_position_reward" / "recasts_exhausted" / ""
@property (nonatomic, strong, nullable) MLTowerGameSixCurrentRewardModel *current_reward;
@end

@interface MLTowerGameSixWithdrawResultModel : NSObject
@property (nonatomic, copy) NSString *request_id;
@property (nonatomic, assign) long long withdraw_id;
@property (nonatomic, assign) NSInteger ticket_id;
@property (nonatomic, assign) long long draw_id;
@property (nonatomic, assign) NSInteger total_num;
@property (nonatomic, assign) NSInteger remaining_temp_num;
@property (nonatomic, copy) NSString *reward_status; // "claimed"
@property (nonatomic, copy) NSString *ticket_status; // "completed"
@property (nonatomic, assign) NSInteger remaining_recasts;
@property (nonatomic, assign) NSInteger token_count;
@property (nonatomic, assign) NSInteger can_recast;
@property (nonatomic, assign) NSInteger can_claim;
@property (nonatomic, assign) NSInteger state_version;
@end

NS_ASSUME_NONNULL_END
