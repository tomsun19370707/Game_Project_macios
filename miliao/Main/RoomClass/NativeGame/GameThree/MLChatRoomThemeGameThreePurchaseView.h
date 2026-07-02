#import <UIKit/UIKit.h>
#import "MLGameLotteryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameThreePurchaseView : UIView

+ (void)showInView:(UIView *)parentView 
            infoModel:(MLGameLotteryInfoModel *)info 
     purchaseSuccess:(void(^)(NSInteger newKeyBalance))success;

@end

NS_ASSUME_NONNULL_END
