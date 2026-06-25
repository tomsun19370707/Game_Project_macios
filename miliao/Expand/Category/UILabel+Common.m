//
//  UILabel+Common.h
//
//  Created by dmo on 15/8/5.
//  Copyright (c) 2015年 MHT All rights reserved.
//

#import "UILabel+Common.h"
//当前屏幕高度和568的比例
#define kScreenHeightProportion  ([[UIApplication sharedApplication] statusBarFrame].size.height>20.0 ? (ScreenHeight / 667.0) : (ScreenHeight / 568.0) )
#define kFontProportion kScreenHeightProportion

@implementation UILabel (Common)

- (void)setAttributeWithText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor withBackgroudColor:(UIColor *)backgroundColor
{
    
    self.font = font;
    self.textColor = textColor;
    self.text = text;
    self.backgroundColor = backgroundColor;
}

- (CGSize)contentSizeForWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}

- (CGSize)contentSize
{
    return [self contentSizeForWidth:CGRectGetWidth(self.bounds)];
}

- (BOOL)isTruncated
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    return (size.height > self.frame.size.height);
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.text.length)];
    self.attributedText = attrString;
    [self sizeToFit];
}


- (void)rangeTextStringColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}

- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = str;
}

- (void)rangeTextAttributeWithColor:(UIColor *)color withFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = str;
}


#pragma mark 获取label文字的宽度
- (CGFloat )getTitleTextWidth:(NSString *)title font:(UIFont *)font
{
    CGFloat titleWidth;
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.text = title;
    tempLabel.font = font;
    [tempLabel sizeToFit];
    titleWidth = CGRectGetWidth(tempLabel.frame);
    
    return titleWidth;
}

#pragma mark -- 获取类对象
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

#pragma mark -- 获取label自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark -- 获取label的字体大小
- (void)fontForLabel:(CGFloat)number{
    {
        while (number) {
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:number * kFontProportion]};
            CGSize size=[self.text sizeWithAttributes:attrs];
            if (size.width > self.width) {
                number -= 0.1;
            } else {
                break;
            }
        }
        self.font = [UIFont systemFontOfSize:number];
        
    }
}
#pragma mark -- 更改label字体
- (void)setFontType:(NSString *)typeName {
    if ([self.text length] > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
//        NSLog(@"self.text==%@",self.text);
//        NSLog(@"typeName==%@",typeName);
//        NSLog(@"self.font.pointSize==%f",self.font.pointSize);
//        NSLog(@"self.text.length==%ld",[self.text length]);
        [str addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:typeName size:self.font.pointSize]
                    range:NSMakeRange(0, [self.text length])];
//        NSLog(@"str==%@",str);
        self.attributedText = str;
    }
}

@end
