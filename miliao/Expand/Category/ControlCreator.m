//
//  ControlCreator.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import "ControlCreator.h"

@implementation ControlCreator

#pragma mark create control
+ (UIView *)createView:(UIView *)parent rect:(CGRect)rect backguoundColor:(UIColor *)backguoundColor {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if (parent) {
        [parent addSubview:view];
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UIDatePicker *)createDatePickerView:(UIView *)parent rect:(CGRect)rect backguoundColor:(UIColor *)backguoundColor {
    UIDatePicker *view = [[UIDatePicker alloc] init];
    rect.size.height = view.frame.size.height;
    view.frame = rect;
    view.backgroundColor = [UIColor clearColor];
    view.datePickerMode = UIDatePickerModeDate;
    if (parent) {
        [parent addSubview:view];
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UIPickerView *)createPickerView:(UIView *)parent rect:(CGRect)rect dataSource:(id)dataSource delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor {
    UIPickerView *view = [[UIPickerView alloc] init];
    rect.size.height = view.frame.size.height;
    view.frame = rect;
    view.backgroundColor = [UIColor clearColor];
    view.showsSelectionIndicator = YES;
    view.dataSource = dataSource;
    view.delegate = delegate;
    if (parent) {
        [parent addSubview:view];
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UITableView *)createTableView:(UIView *)parent rect:(CGRect)rect dataSource:(id)dataSource delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor {
    UITableView *view = [[UITableView alloc] initWithFrame:rect];
    view.separatorStyle = UITableViewCellSeparatorStyleNone;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.dataSource = dataSource;
    view.delegate = delegate;
    view.bounces = YES;
    if (parent) {
        [parent addSubview:view];
    }
    
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UIScrollView *)createScrollView:(UIView *)parent rect:(CGRect)rect delegate:(id)delegate backguoundColor:(UIColor *)backguoundColor {
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:rect];
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.delegate = delegate;
    view.bounces = YES;
    if (parent) {
        [parent addSubview:view];
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UIImageView *)createImageView:(UIView *)parent rect:(CGRect)rect imageName:(NSString *)imageName backguoundColor:(UIColor *)backguoundColor {
    UIImageView *view = [[UIImageView alloc] initWithFrame:rect];
    view.contentMode = UIViewContentModeScaleAspectFit;
    if (parent) {
        [parent addSubview:view];
    }
    if (imageName && ![imageName isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            view.image = image;
        }
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

+ (UILabel *)createLabel:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor align:(NSTextAlignment)align lines:(NSInteger)lines {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    if (parent) {
        [parent addSubview:label];
    }
    if (text) {
        label.text = text;
    }
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    if (backguoundColor) {
        label.backgroundColor = backguoundColor;
    }
    label.textAlignment = align;
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
//    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}
+ (EdgeInsetsLabel *)createEdgeInsetsLabel:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor align:(NSTextAlignment)align lines:(NSInteger)lines
{
    EdgeInsetsLabel *label = [[EdgeInsetsLabel alloc] initWithFrame:rect];
    if (parent) {
        [parent addSubview:label];
    }
    if (text) {
        label.text = text;
    }
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    if (backguoundColor) {
        label.backgroundColor = backguoundColor;
    }
    label.textAlignment = align;
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}
+ (UIButton *)createButton:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (parent) {
        [parent addSubview:button];
    }
    button.frame = rect;
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (backguoundColor) {
        [button setBackgroundColor:backguoundColor];
    }
    if (imageName && ![imageName isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    if (target && [target respondsToSelector:action]) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    //    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

+ (UITextField *)createTextField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor {
    UITextField *inputField = [[UITextField alloc] initWithFrame:rect];
    if (parent) {
        [parent addSubview:inputField];
    }
    if (placeholder) {
        NSMutableAttributedString *notice = [[NSMutableAttributedString alloc] initWithString:placeholder];
        if (placeholderColor) {
            [notice addAttribute:NSForegroundColorAttributeName value:placeholderColor range:NSMakeRange(0, placeholder.length)];
        }
        inputField.attributedPlaceholder = notice;
    }
    if (text) {
        inputField.text = text;
    }
    if (font) {
        inputField.font = font;
    }
    if (color) {
        inputField.textColor = color;
    }
    if (backguoundColor) {
        inputField.backgroundColor = backguoundColor;
    }
    inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    inputField.returnKeyType = UIReturnKeyDone;
    
    return inputField;
}

+ (UITextField *)createNumberField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor {
    UITextField *inputField = [ControlCreator createTextField:parent rect:rect placeholder:placeholder placeholderColor:placeholderColor text:text font:font color:color backguoundColor:backguoundColor];
    inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    return inputField;
}

+ (UITextField *)createSecureField:(UIView *)parent rect:(CGRect)rect placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor {
    UITextField *inputField = [ControlCreator createTextField:parent rect:rect placeholder:placeholder placeholderColor:placeholderColor text:text font:font color:color backguoundColor:backguoundColor];
    inputField.secureTextEntry = YES;
    
    return inputField;
}

+ (UITextView *)createTextView:(UIView *)parent rect:(CGRect)rect text:(NSString *)text font:(UIFont *)font color:(UIColor *)color backguoundColor:(UIColor *)backguoundColor {
    UITextView *view = [[UITextView alloc] initWithFrame:rect];
    if (parent) {
        [parent addSubview:view];
    }
    if (text) {
        view.text = text;
    }
    if (font) {
        view.font = font;
    }
    if (color) {
        view.textColor = color;
    }
    if (backguoundColor) {
        view.backgroundColor = backguoundColor;
    }
    
    return view;
}

#pragma mark calcu text size
+ (CGSize)calcuTextSize:(NSString *)text containSize:(CGSize)containSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:lineBreakMode];
    
    CGSize size = CGSizeZero;
    if (CGSizeEqualToSize(containSize, CGSizeZero)) {
        size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    } else {
        CGRect rect = [text boundingRectWithSize:containSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style}
                                         context:nil];
        size = rect.size;
    }
    
    return size;
}

+ (CGSize)calcuAttributeTextSize:(NSMutableAttributedString *)attributeText containSize:(CGSize)containSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:lineBreakMode];
    
    CGSize size = CGSizeZero;
    if (CGSizeEqualToSize(containSize, CGSizeZero)) {
        CGRect rect = [attributeText boundingRectWithSize:CGSizeMake(INT32_MAX, INT32_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
        size = rect.size;
    } else {
        CGRect rect = [attributeText boundingRectWithSize:containSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
        size = rect.size;
    }
    
    return size;
}

#pragma mark create color use hex
+ (UIColor *)colorWithHex:(long)hexColor {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF)) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF)) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}




@end
