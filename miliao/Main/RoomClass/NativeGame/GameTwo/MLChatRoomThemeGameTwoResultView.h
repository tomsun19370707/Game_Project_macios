#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

@interface MLChatRoomThemeGameTwoResultView : UIView

/**
 弹出并展示神木栖灵中奖结果弹窗
 */
+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^)(void))retry;

@end
