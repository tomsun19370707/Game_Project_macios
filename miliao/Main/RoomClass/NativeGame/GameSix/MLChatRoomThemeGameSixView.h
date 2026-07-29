#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 玩法6（玲珑珍宝塔）主弹窗 View
 */
@interface MLChatRoomThemeGameSixView : UIView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
