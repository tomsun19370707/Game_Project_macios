//
//  MLChatRoomUnifiedExchangeConfirmDialog.h
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import <UIKit/UIKit.h>
#import "MLUnifiedExchangeItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLUnifiedExchangeConfirmSuccessBlock)(void);

@interface MLChatRoomUnifiedExchangeConfirmDialog : UIView

@property (nonatomic, copy, nullable) MLUnifiedExchangeConfirmSuccessBlock successBlock;

+ (instancetype)showWithItem:(MLUnifiedExchangeItem *)item
                      inView:(nullable UIView *)parentView
                     success:(nullable MLUnifiedExchangeConfirmSuccessBlock)successBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
