//
//  UIView+Additions.h
//  CAIBADOU1
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+BSCustome.h"

@interface UIView (AdditionsDy)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationHeight;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 * Set view's layer bound color
 */
- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)borderWidth;

-(CGPoint)originBottomRight;



//磨砂效果
/**
 *  Add blur effect.
 *
 *  @param radius blur radius
 */
- (void)blurWithRadius:(float)radius;

/**
 *  Quick way to add blur effect.
 */
- (void)blur;

/**
 *  Remove blur effect.
 */
- (void)unBlur;


/** 支持view拖拽*/
/**
 *  Make view draggable.
 *
 *  @param view    Animator reference view, usually is super view.
 *  @param damping Value from 0.0 to 1.0. 0.0 is the least oscillation. default is 0.4.
 */
- (void)makeDraggable;
- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping;

/**
 *  Disable view draggable.
 */
- (void)removeDraggable;

/**
 *  If you call make draggable method in the initialize method such as `-initWithFrame:`,
 *  `-viewDidLoad`, the view may not be layout correctly at that time. So you should
 *  update snap point in `-layoutSubviews` or `-viewDidLayoutSubviews`.
 *
 *  By the way, you can call make draggable method in `-layoutSubviews` or
 *  `-viewDidLayoutSubviews` directly instead of update snap point.
 */
- (void)updateSnapPoint;

/** 增加圆角*/
- (void)makeRoundCorner;

/** 增加圆角、边框*/
- (void)makeRoundCornerAndLayerColor:(UIColor *)layerColor ;

/** 商品背景增加边框，阴影*/
- (void)makeShadowBGView;

/** 设置view 从color1 到 color2 的渐变色*/
- (void)makeShadowFromColor:(UIColor *)color1 to:(UIColor *)color2 cornerRadius:(CGFloat)radius;

/** 设置view 从color1 到 color2 的渐变色*/
- (void)makeShadowFromColor:(UIColor *)color1 to:(UIColor *)color2 cornerRadius:(CGFloat)radius direction:(GradientDyType)direction;

/** radius*/
-(void)setShadowOffsetAndCornerRadiusWithRadius:(CGFloat)Radius bgColor:(UIColor *)bgColor;

/** 绘制虚线圆形*/
-(void)createDashline:(UIColor *)lineColor ;

/** 添加指定圆角，角度*/
- (void)makeCornerAt:(UIRectCorner)corner cornerRadii:(CGFloat)cornerRadii;

#pragma mark --- 添加粒子效果begin
/** 添加粒子效果*/
/**
 *  Make view draggable.
 *
 *  @param maskVie  弹框的遮罩view，屏幕等大
 */
- (void)addEmitterLayer:(UIView *)maskVie;
@end
