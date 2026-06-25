//
//  UIView+Utils.m
//  MobileMap
//
//  Created by damingdan on 14/11/17.
//  Copyright (c) 2014年 Kingoit. All rights reserved.
//

#import "UIView+Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(Utils)

- (void) roundCornerWithBorderWidth:(CGFloat) width cornerRadius:(CGFloat) radius borderColor:(UIColor*) color{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

+ (id) loadFromNib {
    NSString* nibName = NSStringFromClass([self class]);
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (NSObject* anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            return anObject;
        }
    }
    return nil;
}

- (void) renderInnerShadow {
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:self.bounds];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:[[UIColor whiteColor] CGColor]];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:4];
    
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.bounds, -42, -42));
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0f].CGPath;
    CGPathAddPath(path, NULL, someInnerPath);
    CGPathCloseSubpath(path);
    
    [shadowLayer setPath:path];
    CGPathRelease(path);
    
    [[self layer] addSublayer:shadowLayer];
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    [maskLayer setPath:someInnerPath];
    [shadowLayer setMask:maskLayer];
}

@end

@implementation UIView (FindViewThatIsFirstResponder)
- (UIView *)findViewThatIsFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findViewThatIsFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end
