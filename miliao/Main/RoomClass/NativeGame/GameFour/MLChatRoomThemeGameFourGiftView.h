#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 玩法 4 (三生福袋 / 魔法幻境) 专属【奖品池】图鉴清单弹窗
 */
@interface MLChatRoomThemeGameFourGiftView : UIView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
