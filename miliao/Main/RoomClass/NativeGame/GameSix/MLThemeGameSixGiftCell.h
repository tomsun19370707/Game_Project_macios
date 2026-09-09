//
//  MLThemeGameSixGiftCell.h
//  miliao
//

#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLThemeGameSixGiftCell : UICollectionViewCell

/// 配置奖品卡片模型
- (void)configureWithModel:(nullable MLTowerGiftModel *)model;

/// 规整下落概率字符串 (如 "50.0000" -> "50%", "2.0000" -> "2%")
+ (nullable NSString *)formatProbability:(nullable NSString *)rawPercent;

@end

NS_ASSUME_NONNULL_END
