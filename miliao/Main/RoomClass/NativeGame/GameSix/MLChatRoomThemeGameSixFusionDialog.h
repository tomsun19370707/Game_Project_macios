//
//  MLChatRoomThemeGameSixFusionDialog.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 门票融合说明与合成弹窗.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameSixFusionDialog : UIView

/// 弹出门票融合说明与合成对话框
/// @param parentView 父视图（传 nil 默认使用 keyWindow）
+ (void)showInView:(nullable UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
