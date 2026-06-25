//
//  NSString+Extension.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (ExtensionA)
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}
//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}



/**
 根据字体、行数、行间距和constrainedWidth计算文本占据的size
 **/
- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
               lineSpacing:(CGFloat)lineSpacing
          constrainedWidth:(CGFloat)constrainedWidth{
    
    if (self.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //  行数
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数，真实高度加上行间距
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
        }
    } else {
        //  行数超过指定行数的时候，限制行数
        if (rows > numberOfLines) {
            rows = numberOfLines;
                }
        realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
    }
    //  返回真实的宽高
    return CGSizeMake(constrainedWidth, realHeight);
}

- (CGSize)textSizeWithFont:(UIFont*)font
             numberOfLines:(NSInteger)numberOfLines
          constrainedWidth:(CGFloat)constrainedWidth{
    
    if (self.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //  行数
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数，真实高度加上行间距
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) ;
        }
    } else {
        //  行数超过指定行数的时候，限制行数
        if (rows > numberOfLines) {
            rows = numberOfLines;
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) ;
    }
    //  返回真实的宽高
    return CGSizeMake(constrainedWidth, realHeight);
}

/// 计算字符串长度（一行时候）
- (CGSize)textSizeWithFont:(UIFont*)font
                limitWidth:(CGFloat)maxWidth {
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 36)options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)  attributes:@{ NSFontAttributeName : font} context:nil].size;
    size.width = size.width > maxWidth ? maxWidth : size.width;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    } else {
        textSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return textSize;
}









@end
