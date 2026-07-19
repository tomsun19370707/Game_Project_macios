//
//  MLChatRoomThemeGameFivePurchaseView.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLGameLotteryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameFivePurchaseView : UIView

+ (void)showInView:(UIView *)parentView 
         infoModel:(MLGameLotteryInfoModel *)info 
   purchaseSuccess:(void(^)(NSInteger newKeyBalance))success;

@end

NS_ASSUME_NONNULL_END
