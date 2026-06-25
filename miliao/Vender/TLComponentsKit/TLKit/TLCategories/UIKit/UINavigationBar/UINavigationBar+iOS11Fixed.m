//
//  UINavigationBar+iOS11Fixed.m
//  AFNetworking
//
//  Created by 李伯坤 on 2017/12/25.
//

#import "UINavigationBar+iOS11Fixed.h"
#import <objc/runtime.h>

@implementation UINavigationBar (iOS11Fixed)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method newMethod = class_getInstanceMethod(self, @selector(tt_layoutSubviews));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)tt_layoutSubviews
{
    [self tt_layoutSubviews];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
        self.layoutMargins = UIEdgeInsetsZero;
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass(view.class) containsString:@"ContentView"]) {
//                view.layoutMargins = UIEdgeInsetsZero;
                if (@available(iOS 13.0, *)) {
                    UIEdgeInsets margins = view.layoutMargins;
                    CGRect frame = view.frame;
                    frame.origin.x = -margins.left;
                    frame.origin.y = -margins.top;
                    frame.size.width += (margins.left + margins.right);
                    frame.size.height += (margins.top + margins.bottom);
                    view.frame = frame;
                }else {
                    view.layoutMargins = UIEdgeInsetsZero;
                }
                break;
            }
        }
    }
}

@end
