//
//  UISwipeGestureRecognizer+HALRTL.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UISwipeGestureRecognizer+HALRTL.h"

@implementation UISwipeGestureRecognizer (HALRTL)
+ (void)load
{
    Method oldAttMethod = class_getInstanceMethod(self,@selector(setDirection:));
    Method newAttMethod = class_getInstanceMethod(self,@selector(rtl_setDirection:));
    method_exchangeImplementations(oldAttMethod, newAttMethod);  //交换成功
   
}

- (void)rtl_setDirection:(UISwipeGestureRecognizerDirection)direction
{
    
    if (isRTL()) {
        if (direction == UISwipeGestureRecognizerDirectionRight) {
            direction = UISwipeGestureRecognizerDirectionLeft;
        } else if (direction == UISwipeGestureRecognizerDirectionLeft) {
            direction = UISwipeGestureRecognizerDirectionRight;
        }
    }
    [self rtl_setDirection:direction];
}
@end
