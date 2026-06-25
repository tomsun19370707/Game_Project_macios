//
//  UIButton+ExteralButton.h
//  100PiFa
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ExteralButton)
@property (nonatomic,strong)NSIndexPath *indexP;
//圆角的button，边框线
+ (UIButton *)buttonWithRoundBoderForTitle:(NSString *)title target:(id)target action:(SEL)action;
//添加一个image
+ (UIButton *)buttonWithImage:(UIImage *)image target:(id)target action:(SEL)action frame:(CGRect)frame;
//一个普通的button，给定一个标题，并添加事件
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action frame:(CGRect)frame isWhite:(BOOL)isWhite;
/**
 RAC- button初始化，标题，图片，frame，字号,字体颜色
 */
+ (UIButton *)racButtonWithTitle:(NSString *)title BGImage:(UIImage *)image frame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)titleColor;

/**  设置button宽度*/
- (void)fetchButtonWidth ;
@end
