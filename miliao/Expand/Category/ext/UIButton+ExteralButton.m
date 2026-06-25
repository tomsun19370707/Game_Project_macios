//
//  UIButton+ExteralButton.m
//  100PiFa
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

/*
 1.category使用 objc_setAssociatedObject/objc_getAssociatedObject 实现添加属性
 2.属性 其实就是get/set 方法。我们可以使用  objc_setAssociatedObject/objc_getAssociatedObject  实现 动态向类中添加 方法
 */

#import "UIButton+ExteralButton.h"
#import <objc/runtime.h>

static const void *indexPath = &indexPath;

@implementation UIButton (ExteralButton)

@dynamic indexP;

- (NSIndexPath *)indexP
{
    return objc_getAssociatedObject(self, indexPath);
}

/*
 
 //1 源对象UIBUtton
 //2 关键字 唯一静态变量indexPath
 //3 关联的对象 indexP
 //4 关键策略  OBJC_ASSOCIATION_RETAIN_NONATOMIC
 
 */
-  (void)setIndexP:(NSIndexPath *)indexP
{
    objc_setAssociatedObject(self, indexPath, indexP, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/*
 
 另外，objc_removeAssociatedObjects可以删除指定对象实例的所有扩展属性。//不建议使用,删除的时候会删除所有
 
 */








+ (UIButton *)buttonWithRoundBoderForTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    button.titleLabel.textColor = [UIColor blackColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.titleLabel.textColor = [UIColor blackColor];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    return button;
}

+ (UIButton *)buttonWithImage:(UIImage *)image target:(id)target action:(SEL)action frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action frame:(CGRect)frame isWhite:(BOOL)isWhite
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (isWhite) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)racButtonWithTitle:(NSString *)title BGImage:(UIImage *)image frame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)titleColor;
{
    //标题
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    //图片
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    //尺寸
    [button setFrame:frame];
    //字体大小
    if (size > 0) {
        button.titleLabel.font = PingFangFONT(size) ;
    }else{
        button.titleLabel.font = PingFangFONT(14.f) ;
    }
    //字体颜色
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return button;
}

/**  设置button宽度*/
- (void)fetchButtonWidth
{
    CGFloat width = [NSString widthForContent:self.titleLabel.text font:self.titleLabel.font] + 20 ;
    self.width = width ;
}
@end
