//
//  MLChatRoomThemeGameSixRuleDialog.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 游戏规则说明弹窗.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameSixRuleDialog : UIView

/// 弹出规则说明对话框
/// @param parentView 父视图（传 nil 默认使用 keyWindow）
+ (void)showInView:(nullable UIView *)parentView;

/// 弹出自定义规则内容的说明对话框
/// @param parentView 父视图
/// @param ruleContent 自定义规则文本
+ (void)showInView:(nullable UIView *)parentView ruleContent:(nullable NSString *)ruleContent;

@end

NS_ASSUME_NONNULL_END
