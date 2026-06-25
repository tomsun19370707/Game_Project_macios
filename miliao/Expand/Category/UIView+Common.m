//
//  UIView+Common.m
//
//  Created by dmo on 15/6/23.
//  Copyright (c) 2015年 MHT All rights reserved.
//

#import "UIView+Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Common)


#pragma mark - Corner radius

-(void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    CAShapeLayer*   frameLayer = [CAShapeLayer layer];
    frameLayer.frame = bounds;
    frameLayer.path = maskPath.CGPath;
//    frameLayer.strokeColor = [UIColor redColor].CGColor;
    frameLayer.fillColor = nil;
    
    [self.layer addSublayer:frameLayer];
}

-(void)roundTopCornersRadius:(CGFloat)radius
{
    [self roundCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) radius:radius];
}

-(void)roundBottomCornersRadius:(CGFloat)radius
{
    [self roundCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) radius:radius];
}

- (void)setCornerRadius:(CGFloat)size
{
    self.layer.cornerRadius = size;
    self.clipsToBounds = YES;
}

- (void)setCornerRadiusHalfHeight
{
    CGFloat height = self.frame.size.height;
    [self setCornerRadius:height/2];
}



#pragma mark - Border

- (void)setBorder:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}



#pragma mark - shadow

/// 设置阴影
/// @param offset 阴影偏移量
/// @param radius 模糊计算的半径
/// @param color 颜色
/// @param opacity 阴影透明度
- (void)setShadow:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity
{
    self.layer.shadowOffset = offset;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

#pragma mark - separator line

- (UIView *)generateSeparatorLine:(CGRect)rect WithBackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backgroundColor;
    
    return view;
}

- (void)addSeparatorLineWithRect:(CGRect)rect withBackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [self generateSeparatorLine:rect WithBackgroundColor:backgroundColor];
    [self addSubview:view];
}

- (void)addSeparatorLine:(Direction)direction withBorderWidth:(CGFloat)borderWidth withBackgroundColor:(UIColor *)backgroundColor
{
    CGRect rect;
    if ( direction == DirectionTop ) {
        rect = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    } else if ( direction == DirectionBottom ) {
        rect = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    } else if ( direction == DirectionBottom ) {
        rect = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    } else if ( direction == DirectionRight ) {
        rect = CGRectMake(0, self.frame.size.width - borderWidth, borderWidth, self.frame.size.height);
    } else {
        return;
    }
    
    UIView *view = [self generateSeparatorLine:rect WithBackgroundColor:backgroundColor];
    [self addSubview:view];
}


#pragma mark -- 获取类对象
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

@end
