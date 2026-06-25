//
//  UITabBar+Badge.h
//  miliao
//
//  Created by aa on 2019/9/26.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Badge)
- (void)showBadgeOnItemIndex:(int)index color:(UIColor *)color;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
- (void)showBageOnItemWithIndex:(int)index value:(NSString *)valueStr color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
