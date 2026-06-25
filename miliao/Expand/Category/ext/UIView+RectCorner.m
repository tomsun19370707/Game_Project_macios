
//
//  UIView+RectCorner.m
//  DotInvest
//
//  Created by shanchao on 2019/7/6.
//  Copyright © 2019 shanchao. All rights reserved.
//

#import "UIView+RectCorner.h"

@implementation UIView (RectCorner)

- (void)setCornerOnTopWithSize:(CGSize)size {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    

    
}

- (void)setCornerOnBottomWithSize:(CGSize)size {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

    
}
- (void)setCornerOnLeftWithSize:(CGSize)size {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    
}
- (void)setCornerOnRightWithSize:(CGSize)size {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    
}
- (void)setAllCornerWithFloat:(CGFloat)size {
    
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    

    
}

- (void)setNoneCorner {
    self.layer.mask = nil;
    
}

@end
