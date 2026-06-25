//
//  UILabel+Common.h
//
//  Created by dmo on 15/8/5.
//  Copyright (c) 2015年 MHT All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

- (CGSize)contentSizeForWidth:(CGFloat)width;
- (CGSize)contentSize;
- (BOOL)isTruncated;


/**
 *	@brief 设置label属性
 */
- (void)setAttributeWithText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor withBackgroudColor:(UIColor *)backgroundColor;

/**
 *	@brief  设置行间距
 */
- (void)setLineSpacing:(CGFloat)lineSpacing;


/**
 *	@brief 设置不同label中在不同区间的字体颜色
 */
- (void)rangeTextStringColor:(UIColor *)color range:(NSRange)range;

/**
 *	@brief 设置不同label中在不同区间的字体大小
 */
- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range;


/**
 *	@brief 设置不同label中在不同区间的字体大小和颜色
 */
- (void)rangeTextAttributeWithColor:(UIColor *)color withFont:(UIFont *)font range:(NSRange)range;

//  @brief 根据宽度自适应
//- (void)setLabelSizeToFitWidth:(int)width;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

#pragma mark -- 获取类对象
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font;

#pragma mark -- 获取label的字体大小
- (void)fontForLabel:(CGFloat)number;

#pragma mark -- 更改label字体
- (void)setFontType:(NSString *)typeName;

#pragma mark 获取label文字的宽度
- (CGFloat )getTitleTextWidth:(NSString *)title font:(UIFont *)font;


@end
