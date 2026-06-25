//
//  UIView+HTSRTL.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/12/7.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UIView+HTSRTL.h"
//对于已经完成frame布局的view，我们只需要在最后对view调用resetFrameToFitRTL，即可适配RTL
@implementation UIView (HTSRTL)
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
