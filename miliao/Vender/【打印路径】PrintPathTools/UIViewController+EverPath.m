//
//  UIViewController+EverPath.m
//  EverShowPath
//
//  Created by Ever on 17/1/2.
//  Copyright © 2017年 Beijing Byecity International Travel CO., Ltd. All rights reserved.
//  欢迎关注微信公众号：iOS狗
//

#import "UIViewController+EverPath.h"
#import <objc/runtime.h>
#import "EverPathMacro.h"

@implementation UIViewController (EverPath)

+ (void)load
{
#ifdef DEBUG
#if kPrintPathLog == 1
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        Method m1 = class_getInstanceMethod(cls, @selector(viewDidAppear:));
        Method m3 = class_getInstanceMethod(cls, @selector(viewDidAppear_EverPath));
        method_exchangeImplementations(m1, m3);
    });
#endif
#endif
}

- (void)viewDidAppear_EverPath
{
    [self viewDidAppear_EverPath];
    //   进入
    NSString *lastClassString = [[NSUserDefaults standardUserDefaults] objectForKey:@"fromTarget"];
    //  如果 lastClassString 存在列表中
    if (!lastClassString) {
        [[NSUserDefaults standardUserDefaults] setObject:@"AKHomeViewController" forKey:@"fromTarget"];
    } else {
        NSString *selfClass = [NSString stringWithFormat:@"%@",self.class];
        NSString *selfSuperClass = [NSString stringWithFormat:@"%@",self.class.superclass];
        if (([selfSuperClass isEqualToString:@"XYBaseViewController"] || [selfSuperClass isEqualToString:@"UIViewController"] || [selfSuperClass isEqualToString:@"BaseRefreshTableViewController"]) && ![selfClass isEqualToString:@"UIAlertController"] && ![selfClass isEqualToString:@"UIApplicationRotationFollowingController"]) {
            [[NSUserDefaults standardUserDefaults] setObject:selfClass forKey:@"fromTarget"];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    MYLog(@"Ever_VC_Path:%s\n",NSStringFromClass(self.class).UTF8String);
}

@end
