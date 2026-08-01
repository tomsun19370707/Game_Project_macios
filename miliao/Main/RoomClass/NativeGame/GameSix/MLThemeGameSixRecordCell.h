#import <UIKit/UIKit.h>
#import "MLTowerGameSixModels.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 玩法6（玲珑珍宝塔）开奖记录卡片 Cell
 */
@interface MLThemeGameSixRecordCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) UIImageView *giftIconImageView;
@property (nonatomic, strong) UILabel *giftNameLabel;

- (void)renderRecordWithGiftName:(NSString *)giftName count:(NSInteger)count imageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
