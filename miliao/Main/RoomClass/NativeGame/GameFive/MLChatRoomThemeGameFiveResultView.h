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
        totalValue:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
