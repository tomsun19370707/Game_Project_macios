//
//  UIView+Additions.m
//  CAIBADOU1
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "UIView+AdditionsDy.h"
#import <objc/runtime.h>
/** 粒子动画*/
#define EmitterColor_Red      [UIColor colorWithRed:255/255.0 green:0 blue:139/255.0 alpha:1]
#define EmitterColor_Yellow   [UIColor colorWithRed:251/255.0 green:197/255.0 blue:13/255.0 alpha:1]
#define EmitterColor_Blue     [UIColor colorWithRed:50/255.0 green:170/255.0 blue:207/255.0 alpha:1]

static NSInteger LCBlurBlurredImageView = -100; // blurred image view's tag
static NSInteger LCBlurOverlay          = -101; // overlay's tag


UIInterfaceOrientation ITTInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    return orient;
}

CGRect ITTScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}


@implementation UIView (AdditionsDy)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.height : self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.width : self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}


-(CGPoint)originBottomRight
{
    return CGPointMake(self.left+self.width, self.top+self.height);
}



- (void)blurWithRadius:(float)radius {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIContext *context  = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:viewImage.CGImage];
    
    CIFilter *gaussianBlurFilter  = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:inputImage forKey:@"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *outputImage          = [gaussianBlurFilter valueForKey:@"outputImage"];
    
    CGImageRef cgImage            = [context createCGImage:outputImage fromRect:self.bounds];
    UIImage *blurredImage         = [UIImage imageWithCGImage:cgImage];
    UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    blurredImageView.tag          = LCBlurBlurredImageView;
    blurredImageView.image        = blurredImage;
    
    UIView *overlay               = [[UIView alloc] initWithFrame:self.bounds];
    overlay.tag                   = LCBlurOverlay;
    overlay.backgroundColor       = [UIColor colorWithRed:1.0f
                                                    green:1.0f
                                                     blue:1.0f
                                                    alpha:0.8f];
    
    [self addSubview:blurredImageView];
    [self addSubview:overlay];
}

/**
 *  Quick way to add blur effect.
 */
- (void)blur {
    [self blurWithRadius:15.0f];
}

/**
 *  Remove blur effect.
 */
- (void)unBlur {
    [[self viewWithTag:LCBlurBlurredImageView] removeFromSuperview];
    [[self viewWithTag:LCBlurOverlay] removeFromSuperview];
}

- (void)makeDraggable
{
    NSAssert(self.superview, @"Super view is required when make view draggable");
    
    [self makeDraggableInView:self.superview damping:0.4];
}

- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping
{
    if (!view) return;
    [self removeDraggable];
    
    self.zy_playground = view;
    self.zy_damping = damping;
    
    [self zy_creatAnimator];
    [self zy_addPanGesture];
}

- (void)removeDraggable
{
    [self removeGestureRecognizer:self.zy_panGesture];
    self.zy_panGesture = nil;
    self.zy_playground = nil;
    self.zy_animator = nil;
    self.zy_snapBehavior = nil;
    self.zy_attachmentBehavior = nil;
    self.zy_centerPoint = CGPointZero;
}

- (void)updateSnapPoint
{
    self.zy_centerPoint = [self convertPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) toView:self.zy_playground];
    self.zy_snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.zy_centerPoint];
    self.zy_snapBehavior.damping = self.zy_damping;
}

- (void)zy_creatAnimator
{
    self.zy_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.zy_playground];
    [self updateSnapPoint];
}

- (void)zy_addPanGesture
{
    self.zy_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zy_panGesture:)];
    [self addGestureRecognizer:self.zy_panGesture];
}

#pragma mark - Gesture

- (void)zy_panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint panLocation = [pan locationInView:self.zy_playground];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        UIOffset offset = UIOffsetMake(panLocation.x - self.zy_centerPoint.x, panLocation.y - self.zy_centerPoint.y);
        [self.zy_animator removeAllBehaviors];
        self.zy_attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self
                                                               offsetFromCenter:offset
                                                               attachedToAnchor:panLocation];
        [self.zy_animator addBehavior:self.zy_attachmentBehavior];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        [self.zy_attachmentBehavior setAnchorPoint:panLocation];
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled ||
             pan.state == UIGestureRecognizerStateFailed)
    {
        [self.zy_animator removeAllBehaviors];
        [self.zy_animator addBehavior:self.zy_snapBehavior];
    }
}

#pragma mark - Associated Object

- (void)setZy_playground:(id)object {
    objc_setAssociatedObject(self, @selector(zy_playground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)zy_playground {
    return objc_getAssociatedObject(self, @selector(zy_playground));
}

- (void)setZy_animator:(id)object {
    objc_setAssociatedObject(self, @selector(zy_animator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIDynamicAnimator *)zy_animator {
    return objc_getAssociatedObject(self, @selector(zy_animator));
}

- (void)setZy_snapBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(zy_snapBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UISnapBehavior *)zy_snapBehavior {
    return objc_getAssociatedObject(self, @selector(zy_snapBehavior));
}

- (void)setZy_attachmentBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(zy_attachmentBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAttachmentBehavior *)zy_attachmentBehavior {
    return objc_getAssociatedObject(self, @selector(zy_attachmentBehavior));
}

- (void)setZy_panGesture:(id)object {
    objc_setAssociatedObject(self, @selector(zy_panGesture), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)zy_panGesture {
    return objc_getAssociatedObject(self, @selector(zy_panGesture));
}

- (void)setZy_centerPoint:(CGPoint)point {
    objc_setAssociatedObject(self, @selector(zy_centerPoint), [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)zy_centerPoint {
    return [objc_getAssociatedObject(self, @selector(zy_centerPoint)) CGPointValue];
}

- (void)setZy_damping:(CGFloat)damping {
    objc_setAssociatedObject(self, @selector(zy_damping), @(damping), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)zy_damping {
    return [objc_getAssociatedObject(self, @selector(zy_damping)) floatValue];
}

/** 增加圆角*/
- (void)makeRoundCorner
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height / 2 ;
}

/** 增加圆角、边框*/
- (void)makeRoundCornerAndLayerColor:(UIColor *)layerColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height / 2 ;
    self.layer.borderColor = layerColor.CGColor ;
    self.layer.borderWidth = 1.0 ;
}

/** 商品背景增加边框，阴影*/
- (void)makeShadowBGView
{
//    /** 商品背景增加边框，阴影*/
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = 8 ;
//    // 阴影颜色
//    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    // 阴影偏移，默认(0, -3)
//    self.layer.shadowOffset = CGSizeMake(0,-1);
//    // 阴影透明度，默认0
//    self.layer.shadowOpacity = 0.5;
//    // 阴影半径，默认3
//    self.layer.shadowRadius = 5;
    
    
    
    /** 这种方法可以避免 子view被遮挡*/
    self.backgroundColor = LineColor;
    self.layer.cornerRadius = 12;

    // 阴影设置
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 5;

    // 关键：添加阴影路径，提升性能且避免图层混乱
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;

    // 不需要循环调用 bringSubviewToFront:
    // 子视图默认就在父视图图层上方，除非被其他视图遮挡
    // 如果确实需要调整层级，只需将需要显示在最前面的视图单独提前即可
    // 例如：[self bringSubviewToFront:self.importantSubview];
}

/** 设置view 从color1 到 color2 的渐变色*/
- (void)makeShadowFromColor:(UIColor *)color1 to:(UIColor *)color2 cornerRadius:(CGFloat)radius
{
    UIColor *color = [UIColor gradientColors:@[color1,color2] gradientType:GradientDyTypeLeftToRight imgSize:self.size];
    [self setShadowOffsetAndCornerRadiusWithRadius:radius bgColor:color];
}

/** 设置view 从color1 到 color2 的渐变色*/
- (void)makeShadowFromColor:(UIColor *)color1 to:(UIColor *)color2 cornerRadius:(CGFloat)radius direction:(GradientDyType)direction
{
    UIColor *color = [UIColor gradientColors:@[color1,color2] gradientType:direction imgSize:self.size];
    [self setShadowOffsetAndCornerRadiusWithRadius:radius bgColor:color];
}

-(void)setShadowOffsetAndCornerRadiusWithRadius:(CGFloat)Radius bgColor:(UIColor *)bgColor{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    layer.backgroundColor = bgColor.CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowOpacity = 0.5;
    layer.cornerRadius = Radius;
    layer.shadowColor = UIColor.blackColor.CGColor;
    [self.layer addSublayer:layer];
    
    /** 前置view*/
    for (UIView *temp in self.subviews) {
        [self bringSubviewToFront:temp];
    }
}

/** 绘制虚线圆形*/
-(void)createDashline:(UIColor *)lineColor
{
    // 设置默认值
    UIColor * dashColor = HexColorDy(@"999999");
    CGFloat lineWidth = 1.0f;
    CGFloat dashPattern1 = 2.0f;  // 线段长度
    CGFloat dashPattern2 = 3.0f;  // 间隔长度
    
    // 创建贝塞尔路径（圆形）
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.frame, lineWidth/2, lineWidth/2)];
    
    // 创建形状图层
    CAShapeLayer *dashedLayer = [CAShapeLayer layer];
    dashedLayer.frame = self.bounds;
    dashedLayer.path = circlePath.CGPath;
    dashedLayer.strokeColor = dashColor.CGColor;  // 线条颜色
    dashedLayer.fillColor = [UIColor clearColor].CGColor;  // 填充颜色（透明）
    dashedLayer.lineWidth = lineWidth;  // 线条宽度
    dashedLayer.lineCap = kCALineCapRound;  // 线条端点样式
    dashedLayer.lineDashPattern = @[@(dashPattern1), @(dashPattern2)];  // 虚线样式
    
    // 移除之前的图层，避免重复添加
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layer addSublayer:dashedLayer];
}

/** 添加指定圆角，角度*/
- (void)makeCornerAt:(UIRectCorner)corner cornerRadii:(CGFloat)cornerRadii
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height) ;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
#pragma mark --- 添加粒子效果begin
/** 添加粒子效果*/
/**
 *  Make view draggable.
 *
 *  @param maskVie  弹框的遮罩view，屏幕等大
 */
- (void)addEmitterLayer:(UIView *)maskVie
{
    CAEmitterLayer *emitterLayer = [self addEmitterLayer:maskVie window:self];
    [self startAnimate:emitterLayer];
}
- (CAEmitterLayer *)addEmitterLayer:(UIView *)view  window:(UIView *)window
{
    /** 色块粒子*/
    CAEmitterCell *subCell1 = [self subCell:[self imageWithColor:EmitterColor_Red]];
    subCell1.name = @"red";
    CAEmitterCell *subCell2 = [self subCell:[self imageWithColor:EmitterColor_Yellow]];
    subCell2.name = @"yellow";
    CAEmitterCell *subCell3 = [self subCell:[self imageWithColor:EmitterColor_Blue]];
    subCell3.name = @"blue";
    CAEmitterCell *subCell4 = [self subCell:[UIImage imageNamed:@"success_star"]];
    subCell4.name = @"star";
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterSize    = window.bounds.size;
    emitterLayer.emitterMode    = kCAEmitterLayerOutline;
    emitterLayer.emitterShape    = kCAEmitterLayerRectangle;
    emitterLayer.renderMode        = kCAEmitterLayerOldestFirst;
    
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4];
    [view.layer addSublayer:emitterLayer];
    return emitterLayer;
}
-(void)startAnimate:(CAEmitterLayer *)emitterLayer
{
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue        = [NSNumber numberWithFloat:30];
    redBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    redBurst.duration        = 0.5;
    redBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue        = [NSNumber numberWithFloat:30];
    yellowBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    yellowBurst.duration        = 0.5;
    yellowBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    blueBurst.fromValue        = [NSNumber numberWithFloat:30];
    blueBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    blueBurst.duration        = 0.5;
    blueBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.star.birthRate"];
    starBurst.fromValue        = [NSNumber numberWithFloat:30];
    starBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    starBurst.duration        = 0.5;
    starBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[redBurst,yellowBurst,blueBurst,starBurst];
    
    [emitterLayer addAnimation:group forKey:@"heartsBurst"];
}

- (CAEmitterCell *)subCell:(UIImage *)image
{
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.name = @"heart";
    cell.contents = (__bridge id _Nullable)image.CGImage;
    
    // 缩放比例
    cell.scale      = 0.6;
    cell.scaleRange = 0.6;
    // 每秒产生的数量
    //    cell.birthRate  = 20;
    cell.lifetime   = 20;
    // 每秒变透明的速度
    //    snowCell.alphaSpeed = -0.7;
    //    snowCell.redSpeed = 0.1;
    // 秒速
    cell.velocity      = 200;
    cell.velocityRange = 200;
    cell.yAcceleration = 9.8;
    cell.xAcceleration = 0;
    //掉落的角度范围
    cell.emissionRange  = M_PI;
    
    cell.scaleSpeed        = -0.05;
    ////    cell.alphaSpeed        = -0.3;
    cell.spin            = 2 * M_PI;
    cell.spinRange        = 2 * M_PI;
    return cell;
}
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark --- 添加粒子效果end
@end

