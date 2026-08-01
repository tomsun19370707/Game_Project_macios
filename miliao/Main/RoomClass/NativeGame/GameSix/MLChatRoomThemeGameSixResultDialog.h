#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MLTowerGameSixRecastResultModel;

/**
 * 玩法6（玲珑珍宝塔）重铸抽奖结果展示弹窗
 */
@interface MLChatRoomThemeGameSixResultDialog : UIView

@property (nonatomic, copy) void (^onContinueRecastBlock)(void);
@property (nonatomic, copy) void (^onWithdrawSuccessBlock)(void);

+ (instancetype)showInView:(UIView *)parentView resultModel:(MLTowerGameSixRecastResultModel *)resultModel;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
