//
//  MLChatRoomThemeGameSixObsidianExchangeDialog.h
//  miliao
//
//  Created by AI Assistant on 2026/9/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomThemeGameSixObsidianExchangeDialog : UIView

@property (nonatomic, copy, nullable) void (^onExchangeSuccessBlock)(void);

+ (instancetype)showInView:(nullable UIView *)parentView success:(nullable void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
