//
//  MLChatRoomThemeGameSixPackDialog.h
//  miliao
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLThemeGameSixWithdrawSuccessBlock)(void);

@interface MLChatRoomThemeGameSixPackDialog : UIView

@property (nonatomic, copy, nullable) MLThemeGameSixWithdrawSuccessBlock onWithdrawSuccessBlock;

/// 弹出暂存包弹窗
+ (nullable instancetype)showInView:(nullable UIView *)parentView;

/// 关闭弹窗
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
