//
//  UIView+Frame.h
//
//  该分类可以快速设置UIView的 Frame
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
+ (instancetype)xy_viewFromXib;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
/*
 获取当前所在viewcontroller
  @return viewcontroller
 */
- (UIViewController *)getCurrentVC;
#pragma mark-------------------------------------下面是添加分割线的方法-------------------------------

-(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andStartX:(CGFloat)startX andEndX:(CGFloat)endX;
-(void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andStartY:(CGFloat)startY andEndY:(CGFloat)endY;
-(void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
- (UIViewController *)parentController;


@end
