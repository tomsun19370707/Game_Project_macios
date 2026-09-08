#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MLTowerGameSixRecastResultModel;
@class MLTowerGameSixCurrentRewardModel;

/**
 * 玩法6（玲珑珍宝塔）重铸抽奖结果展示弹窗 (对齐方案 A)
 */
@interface MLChatRoomThemeGameSixResultDialog : UIView

@property (nonatomic, copy, nullable) void (^onContinueRecastBlock)(void);
@property (nonatomic, copy, nullable) void (^onClaimRewardBlock)(NSInteger ticketId, long long drawId, NSInteger stateVersion);
@property (nonatomic, copy, nullable) void (^onWithdrawSuccessBlock)(void);

+ (instancetype)showInView:(UIView *)parentView resultModel:(MLTowerGameSixRecastResultModel *)resultModel;

+ (MLTowerGameSixRecastResultModel *)createFromCurrentReward:(MLTowerGameSixCurrentRewardModel *)reward
                                                   canRecast:(NSInteger)canRecast
                                                    canClaim:(NSInteger)canClaim
                                                stateVersion:(NSInteger)stateVersion;

+ (instancetype)showInView:(UIView *)parentView
             currentReward:(MLTowerGameSixCurrentRewardModel *)reward
                 canRecast:(NSInteger)canRecast
                  canClaim:(NSInteger)canClaim
              stateVersion:(NSInteger)stateVersion;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
