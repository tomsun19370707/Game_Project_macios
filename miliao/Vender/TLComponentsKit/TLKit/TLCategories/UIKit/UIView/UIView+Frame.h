//
//  UIView+Frame.h
//  TLKit
//
//  Created by 李伯坤 on 2017/8/27.
//  Copyright © 2017年 libokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//#pragma mark - Origin
//@property (nonatomic, assign) CGPoint origin;
//@property (nonatomic, assign) CGFloat x;
//@property (nonatomic, assign) CGFloat y;
//
//#pragma mark - Size
//@property (nonatomic, assign) CGSize size;
//@property (nonatomic, assign) CGFloat width;
//@property (nonatomic, assign) CGFloat height;
//
//#pragma mark - Center
//@property (nonatomic, assign) CGFloat centerX;
//@property (nonatomic, assign) CGFloat centerY;

#pragma mark - Coords
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

#pragma mark - Max
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;
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
