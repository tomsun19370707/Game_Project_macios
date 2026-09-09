//
//  MLChatRoomThemeGameSixGiftDialog.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 玩法6（玲珑珍宝塔）分层奖品池弹窗
 * 支持 1～7 层快速切换浏览对应席位的奖品卡片与真实下落概率。
 */
@interface MLChatRoomThemeGameSixGiftDialog : UIView

/// 弹出奖品池弹窗
+ (nullable instancetype)showInView:(nullable UIView *)parentView
                             layers:(nullable NSArray<MLTowerLayerInfoModel *> *)layers
                       initialLayer:(NSInteger)initialLayer;

/// 关闭弹窗
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
