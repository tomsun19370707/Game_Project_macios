//
//  MLChatRoomThemeGameTwoGiftView.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameTwoGiftView : UIView

+ (void)showInView:(UIView *)parentView gifts:(NSArray<MLGameDrawResultModel *> *)gifts;

@end

NS_ASSUME_NONNULL_END
