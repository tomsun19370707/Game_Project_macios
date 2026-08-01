//
//  MLThemeGameSixPackGiftCell.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLThemeGameSixPackGiftCell : UICollectionViewCell

/// 配置单元格数据及选中状态
- (void)configureWithModel:(MLTowerGameSixTempInventoryModel *)model isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
