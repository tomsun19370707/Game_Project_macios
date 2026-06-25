//
//  ControlCreator.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EdgeInsetsLabel.h"

@interface ControlCreator : NSObject

#pragma mark create control
+ (UIView *)createView:(UIView *)parent rect:(CGRect)rect backguoundColor:(UIColor *)backguoundColor;
+ (UIDatePicker *)createDatePickerView:(UIView *)parent rect:(CGRect)rect backguoundColor:(UIColor *)backguoundColor;
+ (UIPickerView *)createPickerView:(UIView *)parent rect:(CGRect)rect dataSource:(id)dataSource delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor;
+ (UITableView *)createTableView:(UIView *)parent rect:(CGRect)rect dataSource:(id)dataSource delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor;
+ (UIScrollView *)createScrollView:(UIView *)parent rect:(CGRect)rect delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor;
+ (UIImageView *)createImageView:(UIView *)parent rect:(CGRect)rect imageName:(NSString *)imageName backguoundColor:(UIColor *)backguoundColor;
+ (UILabel *)createLabel:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor align:(NSTextAlignment)align lines:(NSInteger)lines;
+ (EdgeInsetsLabel *)createEdgeInsetsLabel:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor align:(NSTextAlignment)align lines:(NSInteger)lines;
+ (UIButton *)createButton:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor imageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (UITextField *)createTextField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor;
+ (UITextField *)createNumberField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor;
+ (UITextField *)createSecureField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor;
+ (UITextView *)createTextView:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor;

#pragma mark calcu text size
+ (CGSize)calcuTextSize:(NSString *)text containSize:(CGSize)containSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)calcuAttributeTextSize:(NSMutableAttributedString *)attributeText containSize:(CGSize)containSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark create color use hex
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;


@end
