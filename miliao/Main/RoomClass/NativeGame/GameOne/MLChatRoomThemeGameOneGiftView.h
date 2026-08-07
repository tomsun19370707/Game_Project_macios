//
//  MLChatRoomThemeGameOneGiftView.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameOneGiftView : UIView

+ (void)showInView:(UIView *)parentView prizes:(NSArray<MLGameDrawResultModel *> *)prizes;

@end

NS_ASSUME_NONNULL_END
