//
//  NSString+Extension.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ExtensionA)
/**
 * 计算文字高度，可以处理计算带行间距的等属性
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;
/**
 * 计算最大行数文字高度，可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

/**
 根据字体、行数、行间距和指定的宽度constrainedWidth计算文本占据的size
 @param font 字体
 @param numberOfLines 显示文本行数，值为0不限制行数
 @param lineSpacing 行间距
 @param constrainedWidth 文本指定的宽度
  @return 返回文本占据的size
 */
- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
               lineSpacing:(CGFloat)lineSpacing
          constrainedWidth:(CGFloat)constrainedWidth;

/**
 根据字体、行数、行间距和指定的宽度constrainedWidth计算文本占据的size
 @param font 字体
 @param numberOfLines 显示文本行数，值为0不限制行数
 @param constrainedWidth 文本指定的宽度
 @return 返回文本占据的size
 */
- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
          constrainedWidth:(CGFloat)constrainedWidth;

/// 计算字符串长度（一行时候）
- (CGSize)textSizeWithFont:(UIFont*)font
                limitWidth:(CGFloat)maxWidth;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;



@end
