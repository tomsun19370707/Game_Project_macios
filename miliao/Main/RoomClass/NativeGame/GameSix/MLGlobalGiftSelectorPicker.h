//
//  MLGlobalGiftSelectorPicker.h
//  miliao
//
//  Created for Game 6 全局大背包礼物选择弹窗 (1:1 还原 temp/样式.png).
//

#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLGlobalGiftSelectBlock)(MLCandidateItemModel * _Nullable selectedItem, BOOL isClear);

@interface MLGlobalGiftSelectorPicker : UIView

/// 弹出全局大背包礼物选择弹窗
/// @param slotIndex 槽位索引 (0, 1, 2)
/// @param items 全量大背包礼物列表
/// @param selectBlock 选择回调 (selectedItem 为 nil 且 isClear 为 YES 表示清空槽位)
+ (void)showWithSlotIndex:(NSInteger)slotIndex
                    items:(NSArray<MLCandidateItemModel *> *)items
              selectBlock:(MLGlobalGiftSelectBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
