//
//  UIButton+HALRTL.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UIButton+HALRTL.h"

@implementation UIButton (HALRTL)

UIEdgeInsets RTLEdgeInsetsWithInsets(UIEdgeInsets insets) {
    if (insets.left != insets.right && isRTL()) {
        CGFloat temp = insets.left;
        insets.left = insets.right;
        insets.right = temp;
    }
    return insets;
}


+ (void)load{
    if (isRTL()) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method oldMethod = class_getInstanceMethod(self, @selector(setContentEdgeInsets:));
            Method newMethod = class_getInstanceMethod(self, @selector(rtl_setContentEdgeInsets:));
            method_exchangeImplementations(oldMethod, newMethod);
            
            Method oldImageMethod = class_getInstanceMethod(self, @selector(setImageEdgeInsets:));
            Method newImageMethod = class_getInstanceMethod(self, @selector(rtl_setImageEdgeInsets:));
            method_exchangeImplementations(oldImageMethod,newImageMethod);
            
            Method oldTitleMethod = class_getInstanceMethod(self, @selector(setTitleEdgeInsets:));
            Method newTitleMethod = class_getInstanceMethod(self, @selector(rtl_setTitleEdgeInsets:));
            method_exchangeImplementations(oldTitleMethod,newTitleMethod);
        });
    }
}

- (void)rtl_setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    [self rtl_setContentEdgeInsets:RTLEdgeInsetsWithInsets(contentEdgeInsets)];
}

- (void)rtl_setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    [self rtl_setImageEdgeInsets:RTLEdgeInsetsWithInsets(imageEdgeInsets)];
}

- (void)rtl_setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    [self rtl_setTitleEdgeInsets:RTLEdgeInsetsWithInsets(titleEdgeInsets)];
}

@end
