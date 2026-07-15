#import "MLChatRoomThemeGameFourPurchaseView.h"
#import <SVProgressHUD.h>

@implementation MLChatRoomThemeGameFourPurchaseView

+ (void)showInView:(UIView *)parentView 
         infoModel:(MLGameLotteryInfoModel *)info 
   purchaseSuccess:(void(^)(NSInteger newKeyBalance))success {
    [SVProgressHUD showInfoWithStatus:@"兑换钥匙功能正在开发中..."];
}

@end
