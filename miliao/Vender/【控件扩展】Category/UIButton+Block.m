//
//  UIButton+Block.m
//  ZYPZPro
//
//  Created by SystemOuter on 15/11/11.
//  Copyright © 2015年 SystemOuter. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

/**
 *  按钮点击事件 强制内联关键字
 */
static NSString * const kButtonClicekdBlock = @"kButtonClicekdBlock_PZPro";

/**
 *  按钮多点击事件 强制内联关键字
 */
static NSString * const kButtonMutabelClicekdBlock = @"kButtonMutabelClicekdBlock_PZPro";

/**
 *  点击事件状态集数组 强制内联关键字
 */
static NSString * const kButtonControlEventArr = @"kButtonControlEventArr_PZPro";

/**
 *  创建运行时方法模板 Obj-C的方法（method）就是一个至少需要两个参数（self，_cmd）的C函数
 *
 *  @param self 当前copy指针 必写项
 *  @param _cmd 当前命令 必写项
 */
void buttonClicked(id self, SEL _cmd){
    //获得当前运行时的方法名称，并截取出数字
    NSString * str_Number = [[NSStringFromSelector(_cmd) componentsSeparatedByString:@"_"] lastObject];
    //获取当前ControlEvents对应的二进制的十进制
    NSString * str_Events = [str_Number substringWithRange:NSMakeRange(0, str_Number.length - 1)];
    //获取当前点击事件的Block
    ZYPZButtonMutabelClickedBlock clickedBlock = objc_getAssociatedObject(self, &kButtonMutabelClicekdBlock);
    //空判断
    if (clickedBlock) {
        //回调 当前按钮对象 当前ControlEvents触发事件
        clickedBlock(self,[str_Events integerValue]);
    }
}

@implementation UIButton (Block)

- (void)animationl {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.values = @[@1.4, @1.0];
    
    animation.duration = 0.7;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
    
}

#pragma mark- 扩展方法
/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    //返回当前对象
    return btn;
}

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param superView        要添加到的父视图
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addView:(UIView *)superView
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    //添加父视图
    [superView addSubview:btn];
    
    //返回当前对象
    return btn;
}

/**
 *  基础设置
 *
 *  @param basicSet 包含基本设置（参数为当前创建的button）
 */
-(void)button_BasicSet:(ZYPZButtonBasicSetBlock)basicSet
{
    //基础设置
    if (basicSet) {
        basicSet(self);
    }
}

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param controlEvents    点击事件触发方式
 *  @param clickedBlock     点击回调的点击事件(参数为当前创建的button，当前点击的响应方式)
 *  @param superView        要添加到的父视图
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet withControlEvents:(UIControlEvents)controlEvents withClicked:(ZYPZButtonClickedBlock)clickedBlock addView:(UIView *)superView
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(btn, &kButtonClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
    }
    //添加点击事件
    [btn addTarget:btn action:@selector(clickBtn:) forControlEvents:controlEvents];
    
    //添加父视图
    [superView addSubview:btn];
    //返回当前对象
    return btn;
}

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param controlEvents    点击事件触发方式
 *  @param clickedBlock     点击回调的点击事件(参数为当前创建的button，当前点击的响应方式)
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet withControlEvents:(UIControlEvents)controlEvents withClicked:(ZYPZButtonClickedBlock)clickedBlock
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(btn, &kButtonClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
    }
    //添加点击事件
    [btn addTarget:btn action:@selector(clickBtn:) forControlEvents:controlEvents];
    //返回当前对象
    return btn;
}

/**
 *  button按钮，添加点击事件
 *
 *  @param clickedBlock  点击事件
 *  @param controlEvents 点击事件触发方式
 */
-(void)buttonAddTaget:(ZYPZButtonClickedBlock)clickedBlock forControlEvents:(UIControlEvents)controlEvents
{
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(self, &kButtonClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
    }
    [self addTarget:self action:@selector(clickBtn:) forControlEvents:controlEvents];
}

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param clickedBlock     点击事件
 *  @param controlEvents    点击事件触发方式数组<注意：数组中为UIControlEvents的NSNumber值>
 *  @param superView        要添加到的父视图
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithMutabelType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents addView:(UIView *)superView
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(self, &kButtonMutabelClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
        //遍历
        for (NSNumber * numberEvents in controlEvents) {
            //运行时创建方法
            class_addMethod([UIButton class], NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]), (IMP)buttonClicked, "v@:@");
            //给按钮添加动态触控方法
            [btn addTarget:btn action:NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]) forControlEvents:[numberEvents integerValue]];
        }
    }
    //添加父视图
    [superView addSubview:btn];
    //返回当前对象
    return btn;
}

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param clickedBlock     点击事件
 *  @param controlEvents    点击事件触发方式数组<注意：数组中为UIControlEvents的NSNumber值>
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithMutabelType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents
{
    //创建按钮
    UIButton * btn = [UIButton buttonWithType:buttonType];
    //基础设置
    if (basicSet) {
        basicSet(btn);
    }
    
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(self, &kButtonMutabelClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
        //遍历
        for (NSNumber * numberEvents in controlEvents) {
            //运行时创建方法
            class_addMethod([UIButton class], NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]), (IMP)buttonClicked, "v@:@");
            //给按钮添加动态触控方法
            [btn addTarget:btn action:NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]) forControlEvents:[numberEvents integerValue]];
        }
    }
    
    //返回当前对象
    return btn;
}

/**
 *  button按钮，添加点击事件
 *
 *  @param clickedBlock  点击事件
 *  @param controlEvents 点击事件触发方式数组<注意：数组中为UIControlEvents的NSNumber值>
 */
-(void)buttonAddMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents
{
    if (clickedBlock) {
        //强制内联 把点击事件关联
        objc_setAssociatedObject(self, &kButtonMutabelClicekdBlock, clickedBlock, OBJC_ASSOCIATION_COPY);
        //遍历
        for (NSNumber * numberEvents in controlEvents) {
            //运行时创建方法
            class_addMethod([UIButton class], NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]), (IMP)buttonClicked, "v@:@");
            //给按钮添加动态触控方法
            [self addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"buttonClicked_%ld:",(long)[numberEvents integerValue]]) forControlEvents:[numberEvents integerValue]];
        }
    }
}

-(void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    //文字尺寸
    CGSize size = CGSizeZero;
    //系统适配
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        //IOS7.0以上计算文字尺寸
        size = [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    }

    
    if (title.length <= 0) {
//        UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(.0f,.0f,0.0,0.0)];
        [self setImage:image forState:stateType];
        
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setBackgroundColor:kClearColor];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(.0f,.0f,0.0,0.0)];
        [self setTitle:title forState:stateType];
        
    }else{
//        UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-size.height + 5.f,0.0,0.0,-size.width)];
        [self setImage:image forState:stateType];
        
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setBackgroundColor:kClearColor];
//        [self setTitleEdgeInsets:(image.size.height + 3.f,-image.size.width,0.0,0.0)];
        [self setTitle:title forState:stateType];
    }
}


#pragma mark- 按钮点击事件
//普通点击事件
-(void)clickBtn:(UIButton *)btn
{
    ZYPZButtonClickedBlock clickedBlock = objc_getAssociatedObject(btn, &kButtonClicekdBlock);
    if (clickedBlock) {
        clickedBlock(btn);
    }
}

@end
