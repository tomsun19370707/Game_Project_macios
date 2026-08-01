#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomNativeGameView : UIView

+ (void)showInView:(UIView *)parentView;

/// 根据 typeId 通用打开/唤起对应的 Web H5 或 Native 原生游戏弹窗
+ (void)openGameWithTypeId:(NSInteger)typeId parentView:(nullable UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
