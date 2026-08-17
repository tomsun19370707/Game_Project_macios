//
//  MLChatRoomThemeGameFiveResultView.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameFiveResultView : UIView

+ (void)showInView:(UIView *)parentView
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts
        totalValue:(NSInteger)value
        retryBlock:(void(^ _Nullable)(void))retry;

@end

NS_ASSUME_NONNULL_END
