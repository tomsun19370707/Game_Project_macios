//
//  MLChatRoomThemeGameSixGlobalBackpackView.h
//  miliao
//
//  玩法6（玲珑珍宝塔）全局大背包候选礼物选择弹窗
//

#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLGlobalBackpackSelectBlock)(MLCandidateItemModel * _Nullable selectedItem);
typedef void(^MLGlobalBackpackClearBlock)(void);

@interface MLChatRoomThemeGameSixGlobalBackpackView : UIView

+ (void)showInView:(UIView *)parentView 
    candidateGifts:(NSArray<MLCandidateItemModel *> *)gifts 
       selectBlock:(MLGlobalBackpackSelectBlock)selectBlock 
        clearBlock:(MLGlobalBackpackClearBlock)clearBlock;

@end

NS_ASSUME_NONNULL_END
