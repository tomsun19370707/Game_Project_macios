//
//  MLChatRoomThemeGameFiveGiftView.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLGameLotteryInfoModel.h"
#import "MLGameDrawResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameFiveGiftView : UIView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId prizes:(NSArray<MLGameDrawResultModel *> *)prizes;

@end

NS_ASSUME_NONNULL_END
