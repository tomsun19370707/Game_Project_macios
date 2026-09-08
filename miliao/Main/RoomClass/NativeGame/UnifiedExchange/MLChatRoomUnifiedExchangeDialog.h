//
//  MLChatRoomUnifiedExchangeDialog.h
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import <UIKit/UIKit.h>
#import "MLUnifiedExchangeItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MLUnifiedExchangeMode) {
    MLUnifiedExchangeModeBackpack = 0, // 背包礼物兑换黑曜石
    MLUnifiedExchangeModeMall = 1       // 元宝商城兑换礼物
};

typedef void(^MLUnifiedExchangeSuccessBlock)(void);

@interface MLChatRoomUnifiedExchangeDialog : UIView

@property (nonatomic, assign) MLUnifiedExchangeMode currentMode;
@property (nonatomic, copy, nullable) MLUnifiedExchangeSuccessBlock successBlock;

+ (instancetype)showInView:(nullable UIView *)parentView
               defaultMode:(MLUnifiedExchangeMode)mode
                   success:(nullable MLUnifiedExchangeSuccessBlock)successBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
