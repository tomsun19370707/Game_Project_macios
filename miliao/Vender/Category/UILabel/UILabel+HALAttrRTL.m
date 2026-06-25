//
//  UILabel+HALAttrRTL.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UILabel+HALAttrRTL.h"

BOOL isRTLString(NSString *string) {
    if ([string hasPrefix:@"\u202B"] || [string hasPrefix:@"\u202A"]) {
        return YES;
    }
    return NO;
}

NSString * RTLString(NSString *string) {
    if (string.length == 0 || isRTLString(string)) {
        return string;
    }
    if (isRTL()) {
        string = [@"\u202B" stringByAppendingString:string];
    } else {
        string = [@"\u202A" stringByAppendingString:string];
    }
    return string;
}

NSAttributedString *RTLAttributeString(NSAttributedString *attributeString ){
    if (attributeString.length == 0) {
        return attributeString;
    }
    NSRange range;
    NSDictionary *originAttributes = [attributeString attributesAtIndex:0 effectiveRange:&range];
    NSParagraphStyle *style = [originAttributes objectForKey:NSParagraphStyleAttributeName];
    
    if (style && isRTLString(attributeString.string)) {
        return attributeString;
    }
    
    NSMutableDictionary *attributes = originAttributes ? [originAttributes mutableCopy] : [NSMutableDictionary new];
    if (!style) {
        NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        UILabel *test = [UILabel new];
        test.textAlignment = NSTextAlignmentLeft;
        mutableParagraphStyle.alignment = test.textAlignment;
        style = mutableParagraphStyle;
        [attributes setValue:mutableParagraphStyle forKey:NSParagraphStyleAttributeName];
    }
    NSString *string = RTLString(attributeString.string);
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@implementation UILabel (HALAttrRTL)

+(void)load{

    Method oldAttMethod = class_getInstanceMethod(self,@selector(setAttributedText:));
    Method newAttMethod = class_getInstanceMethod(self, @selector(rtl_setAttributedText:));
    method_exchangeImplementations(oldAttMethod, newAttMethod);  //交换成功
    
    Method oldTextMethod = class_getInstanceMethod(self,@selector(setText:));
    Method newTextMethod = class_getInstanceMethod(self,@selector(rtl_setText:));
    method_exchangeImplementations(oldTextMethod, newTextMethod);  //交换成功
}

- (void)rtl_setAttributedText:(NSAttributedString *)attributedText
{
    if (isRTL()) {
        attributedText = RTLAttributeString(attributedText);
       

    }
    [self rtl_setAttributedText:attributedText];
}

- (void)rtl_setText:(NSString *)text
{
    [self rtl_setText:RTLString(text)];
}
@end
