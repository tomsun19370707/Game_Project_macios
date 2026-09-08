//
//  MLUnifiedExchangeGiftCell.h
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import <UIKit/UIKit.h>
#import "MLUnifiedExchangeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLUnifiedExchangeGiftCell : UICollectionViewCell

- (void)configureWithItem:(MLUnifiedExchangeItem *)item isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
