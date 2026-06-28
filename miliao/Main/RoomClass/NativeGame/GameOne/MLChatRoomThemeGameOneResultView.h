#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

@interface MLChatRoomThemeGameOneResultView : UIView

/**
 弹出并展示寻梦之旅中奖结果弹窗
 */
+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^)(void))retry;

- (void)updateGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)value;

@end
