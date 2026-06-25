//
//  UIView+Frame.m
//  Test
//
//

#import "UIView+Frame.h"
#import <objc/runtime.h>
#import <SDWebImage/SDImageCache.h>

@interface UIView()

@property (nonatomic, strong) CALayer *sn_maskLayer;

@end
@implementation UIView (Frame)
+ (instancetype)xy_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
     return self.frame.origin;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}
#pragma mark-------------------------------------下面是添加分割线的方法-------------------------------

-(void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

-(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andStartX:(CGFloat)startX andEndX:(CGFloat)endX{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(startX, self.frame.size.height - borderWidth, endX - startX, borderWidth);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,  0, endX - startX , borderWidth)];
    border.shadowColor = COLOR_e5e5e5.CGColor;
    border.shadowOffset = CGSizeMake(0,2 );
    border.shadowPath = shadowPath.CGPath;
    border.shadowOpacity = 1.0f;
    self.clipsToBounds = NO;
    [self.layer addSublayer:border];
}

-(void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, borderWidth , self.frame.size.height)];
    border.shadowColor = COLOR_e5e5e5.CGColor;
    border.shadowOffset = CGSizeMake(-3, 0);
    border.shadowPath = shadowPath.CGPath;
    border.shadowOpacity = 1.0f;
    self.clipsToBounds = NO;
    [self.layer addSublayer:border];
}

-(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andStartY:(CGFloat)startY andEndY:(CGFloat)endY{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, startY, borderWidth, endY - startY);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, borderWidth  , endY - startY)];
    border.shadowColor = COLOR_e5e5e5.CGColor;
    border.shadowOffset = CGSizeMake(2, 0);
    border.shadowPath = shadowPath.CGPath;
    border.shadowOpacity = 1.0;
    self.clipsToBounds = NO;
    [self.layer addSublayer:border];
    
}

- (UIViewController *)parentController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
