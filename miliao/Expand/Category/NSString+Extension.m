//
//  NSString+Extension.m
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)self_adaptionHost
{
    
    NSString * imgUrlStr = @"";
    if ([self containsString:@"http://"]) {
        imgUrlStr = self;
    }else if([self containsString:@"https://"]){
        imgUrlStr = self;
    }

    return imgUrlStr;
}

- (NSString *)timing{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
//    if (self.length <= 0) {
//        CGSize sizee = CGSizeMake(0.01f, 0.01f);
//        return sizee;
//    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andlineSpacing:(CGFloat) lineSpaceing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineSpacing = lineSpaceing;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName : font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize originSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSString *test = @"我们";
    CGSize wordSize = [test sizeWithFont:font maxSize:maxSize];
    
    CGFloat selfHeight = [self sizeWithFont:font maxSize:maxSize].height;
    
    if (selfHeight <= wordSize.height) {
        
        CGSize newSize = CGSizeMake(originSize.width, font.pointSize);
        
        if (selfHeight == 0) {
            
            newSize = CGSizeMake(originSize.width, 0);
        }
        
        originSize = newSize;
    }
    
    return originSize;
}




- (CGSize)contentSizeWithWidth:(CGFloat)width
                           font:(UIFont *)font
                    lineSpacing:(CGFloat)lineSpacing {
    if (self == nil || [self length] <= 0) {
        return CGSizeMake(0, 0);
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= style.lineSpacing) {
        if ([self containChinese:self]) {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-style.lineSpacing);
        }
    }
    //return ceil(rect.size.height);
    return rect.size;
}

- (BOOL)contentHaveOneLinesWithWidth:(CGFloat)width
                                font:(UIFont *)font
                         lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= style.lineSpacing) {
        return YES;
    } else {
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














@end
