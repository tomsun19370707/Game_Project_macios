//
//  UILabel+HALRTL.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UILabel+HALRTL.h"

@implementation UILabel (HALRTL)
+ (void)load
{
    
    Method oldInitMethod = class_getInstanceMethod(self,@selector(initWithFrame:));
    Method newInitMethod = class_getInstanceMethod(self, @selector(rtl_initWithFrame:));
    method_exchangeImplementations(oldInitMethod, newInitMethod);  //交换成功
    
    Method oldTextMethod = class_getInstanceMethod(self,@selector(setTextAlignment:));
    Method newTextMethod = class_getInstanceMethod(self, @selector(rtl_setTextAlignment:));
    method_exchangeImplementations(oldTextMethod, newTextMethod);  //交换成功
}

- (instancetype)rtl_initWithFrame:(CGRect)frame
{
    if ([self rtl_initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentNatural;
    }
    return self;
}

- (void)rtl_setTextAlignment:(NSTextAlignment)textAlignment
{
    if (isRTL()) {
        if (textAlignment == NSTextAlignmentNatural || textAlignment == NSTextAlignmentLeft) {
            textAlignment = NSTextAlignmentRight;
        } else if (textAlignment == NSTextAlignmentRight) {
            textAlignment = NSTextAlignmentLeft;
        }
    }else{
        if (textAlignment == NSTextAlignmentNatural || textAlignment == NSTextAlignmentLeft) {
            textAlignment = NSTextAlignmentLeft;
        } else if (textAlignment == NSTextAlignmentRight) {
            textAlignment = NSTextAlignmentRight;
        }
    }
    [self rtl_setTextAlignment:textAlignment];
}

- (void)setRTLFrame:(CGRect)frame width:(CGFloat)width
{
    if (isRTL()) {
        if (self.superview == nil) {
            NSAssert(0, @"must invoke after have superView");
        }
        CGFloat x = width - frame.origin.x - frame.size.width;
        frame.origin.x = x;
    }
    self.frame = frame;
}
- (void)setRTLFrame:(CGRect)frame
{
    [self setRTLFrame:frame width:self.superview.frame.size.width];
}
- (void)resetFrameToFitRTL;
{
    [self setRTLFrame:self.frame];
}


@end
