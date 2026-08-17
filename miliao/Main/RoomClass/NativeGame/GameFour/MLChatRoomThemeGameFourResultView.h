#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameFourResultView : UIView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^ _Nullable)(void))retry;

@end

NS_ASSUME_NONNULL_END
