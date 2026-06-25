//
//  UIButton+TouchInterval.m
//  miliao
//
//  Created by 张世浩 on 2022/6/27.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "UIButton+TouchInterval.h"
#import <objc/runtime.h>


@implementation UIButton (TouchInterval)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //方法选择器
        SEL oldSel = @selector(sendAction:to:forEvent:);
        SEL newSel = @selector(wm_sendAction:to:forEvent:);
        // 获取到响应者链事件分发方法
        Method oldMethod = class_getInstanceMethod(self, oldSel);
        // 获取到上面新建的newsel方法
        Method newMethod = class_getInstanceMethod(self, newSel);
        // IMP 指方法实现的指针,每个方法都有一个对应的IMP,
        //调用方法的IMP指针避免方法调用出现死循环问题

        BOOL isAdd = class_addMethod(self, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isAdd) {
            // 将newSel替换成oldMethod
            class_replaceMethod(self, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }else{
            // 给两个方法互换实现
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)wm_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (!self.isExecuteEvent) {
            //设置点击间隔时间,如果未设置,默认为defaultInterval=0.7
            self.timeInterVal = (self.timeInterVal == 0? defaultInterval:self.timeInterVal);
        }
        if (self.isExecuteEvent) {
            //如果是YES,则不发送事件消息
            return;
        }
        if (self.timeInterVal > 0) {
            //在设置的时间内isExecuteEvent为YES
            self.isExecuteEvent = YES;
            //在设置的间隔时间后重新设置isExecuteEvent为NO
            [self performSelector:@selector(setIsExecuteEvent:) withObject:nil afterDelay:self.timeInterVal];
        }
    }
    //在时间间隔内,isExecuteEvent为YES,不会调用此方法
    [self wm_sendAction:action to:target forEvent:event];
}

static const char *UIButton_timeInterValKey = "UIButton_timeInterVal";
- (NSTimeInterval)timeInterVal {
    // 动态获取关联对象
    return [objc_getAssociatedObject(self, UIButton_timeInterValKey) doubleValue];
}

- (void)setTimeInterVal:(NSTimeInterval)timeInterVal {
    // 动态设置关联对象
    objc_setAssociatedObject(self, UIButton_timeInterValKey, @(timeInterVal), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIButton_isExecuteEventKey = "UIButton_isExecuteEvent";
- (void)setIsExecuteEvent:(BOOL)isExecuteEvent {
    // 动态设置关联对象
    objc_setAssociatedObject(self, UIButton_isExecuteEventKey,@(isExecuteEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isExecuteEvent {
    // 动态获取关联对象
    return [objc_getAssociatedObject(self, UIButton_isExecuteEventKey) boolValue];
}
@end
