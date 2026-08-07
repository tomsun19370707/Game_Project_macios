#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 玩法 3 (星辰序章 / 百祥落盘) 专属【奖品池】图鉴清单弹窗
 */
@interface MLChatRoomThemeGameThreeGiftView : UIView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
