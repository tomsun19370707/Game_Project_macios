//
//  MLThemeGameModel.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 网络请求代理层.
//

#import <Foundation/Foundation.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLGameSixSuccessBlock)(id _Nullable responseObj);
typedef void(^MLGameSixFailureBlock)(NSError *error, NSString * _Nullable msg);

@interface MLThemeGameModel : NSObject

/// 单例代理对象
+ (instancetype)sharedInstance;

/// 1. 获取玩法6主页初始化状态 (/api/emo/tower_game_six/bootstrap)
- (void)fetchTowerGameSixBootstrapWithRoomId:(NSString * _Nullable)roomId
                                     success:(MLGameSixSuccessBlock)success
                                     failure:(MLGameSixFailureBlock)failure;

/// 2. 获取融合候选礼物包 (/api/emo/tower_game_six/fusion_candidates)
- (void)fetchTowerGameSixFusionCandidatesWithSuccess:(MLGameSixSuccessBlock)success
                                             failure:(MLGameSixFailureBlock)failure;

/// 3. 融合预览实时算价 (/api/emo/tower_game_six/fusion_preview)
- (void)previewTowerGameSixFusionWithItems:(NSArray<NSDictionary *> *)items
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure;

/// 4. 提交门票合成 (/api/emo/tower_game_six/exchange_ticket)
- (void)exchangeTowerGameSixTicketWithGlobalItems:(NSArray<NSDictionary *> *)globalItems
                                        tempItems:(NSArray<NSDictionary *> *)tempItems
                                     stateVersion:(NSInteger)stateVersion
                                          success:(MLGameSixSuccessBlock)success
                                          failure:(MLGameSixFailureBlock)failure;

/// 5. 提交重铸开奖抽奖 (/api/emo/tower_game_six/recast)
- (void)recastTowerGameSixWithStateVersion:(NSInteger)stateVersion
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure;

/// 6. 查询玩法6暂存包礼物列表 (/api/emo/tower_game_six/temp_inventory)
- (void)fetchTowerGameSixTempInventoryWithSuccess:(MLGameSixSuccessBlock)success
                                           failure:(MLGameSixFailureBlock)failure;

/// 7. 提交暂存包礼物取回大背包 (/api/emo/tower_game_six/withdraw)
- (void)withdrawTowerGameSixTempGiftsWithItems:(NSArray<NSDictionary *> *)items
                                       success:(MLGameSixSuccessBlock)success
                                       failure:(MLGameSixFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
