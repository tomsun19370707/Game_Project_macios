//
//  UIView+RectCorner.h
//  DotInvest
//
//  Created by shanchao on 2019/7/6.
//  Copyright © 2019 shanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RectCorner)
/**
 
 * 顶部圆角
 
 */

- (void)setCornerOnTopWithSize:(CGSize)size;

/**
 
 *  底部圆角
 
 */

- (void)setCornerOnBottomWithSize:(CGSize)size;
/**
 
 *  做部圆角
 
 */
- (void)setCornerOnLeftWithSize:(CGSize)size;
/**
 
 *  右部圆角
 
 */
- (void)setCornerOnRightWithSize:(CGSize)size;

/**
 
 *  全部圆角
 
 */

- (void)setAllCornerWithFloat:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
