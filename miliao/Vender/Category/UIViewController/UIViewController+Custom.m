//
//  UIViewController+Custom.m
//  FaceShow
//
//  Created by gchao on 2018/7/20.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

- (void)refreshStatusBar:(BOOL)hidden {
    [self setStatusBarHidden:hidden];
    [[[UIApplication sharedApplication].windows firstObject].rootViewController setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)statusBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStatusBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(hidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)prefersStatusBarHidden {
    return [self statusBarHidden];
}

@end
