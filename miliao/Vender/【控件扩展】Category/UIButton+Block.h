//
//  UIButton+Block.h
//  ZYPZPro
//
//  Created by SystemOuter on 15/11/11.
//  Copyright © 2015年 SystemOuter. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark- TYPEDEF_BLOCK
/**
 *  button基本设置Block
 *
 *  @param btn 当前要设置的button
 */
typedef void (^ZYPZButtonBasicSetBlock)(UIButton * btn);

/**
 *  按钮点击回调事件
 *
 *  @param btn 当前点击的对象
 */
typedef void(^ZYPZButtonClickedBlock)(UIButton * btn);

/**
 *  按钮多绑定事件
 *
 *  @param btn          当前按钮对象
 *  @param controlEvent 当前按钮事件触发方式
 */
typedef void(^ZYPZButtonMutabelClickedBlock)(UIButton * btn , UIControlEvents controlEvent);

@interface UIButton (Block)

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet;

/**
 *  button基本设置Block
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param superView        要添加到的父视图
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addView:(UIView *)superView;

/**
 *  基础设置
 *
 *  @param basicSet 包含基本设置（参数为当前创建的button）
 */
-(void)button_BasicSet:(ZYPZButtonBasicSetBlock)basicSet;

/**
 *  button基本设置Block + 点击事件
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param controlEvents    点击事件触发方式
 *  @param clickedBlock     点击回调的点击事件(参数为当前创建的button，当前点击的响应方式)
 *  @param superView        要添加到的父视图
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet withControlEvents:(UIControlEvents)controlEvents withClicked:(ZYPZButtonClickedBlock)clickedBlock addView:(UIView *)superView;

/**
 *  button基本设置Block + 点击事件
 *
 *  @param buttonType       按钮类型
 *  @param basicSet         包含基本设置（参数为当前创建的button）
 *  @param controlEvents    点击事件触发方式
 *  @param clickedBlock     点击回调的点击事件(参数为当前创建的button，当前点击的响应方式)
 *
 *  @return 返回创建好的按钮
 */
+(UIButton *)button_AllocWithType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet withControlEvents:(UIControlEvents)controlEvents withClicked:(ZYPZButtonClickedBlock)clickedBlock;

/**
 *  button按钮，添加点击事件
 *
 *  @param clickedBlock  点击事件
 *  @param controlEvents 点击事件触发方式
 */
-(void)buttonAddTaget:(ZYPZButtonClickedBlock)clickedBlock forControlEvents:(UIControlEvents)controlEvents;

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
+(UIButton *)button_AllocWithMutabelType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents addView:(UIView *)superView;

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
+(UIButton *)button_AllocWithMutabelType:(UIButtonType)buttonType basicSet:(ZYPZButtonBasicSetBlock)basicSet addMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents;

/**
 *  button按钮，添加点击事件
 *
 *  @param clickedBlock  点击事件
 *  @param controlEvents 点击事件触发方式
 */
-(void)buttonAddMutabelTaget:(ZYPZButtonMutabelClickedBlock)clickedBlock forControlEvents:(NSArray<NSNumber *>*)controlEvents;

/**
 *  设置图文
 *
 *  @param image     设置图片
 *  @param title     设置标题
 *  @param stateType 设置显示状态
 */
-(void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

- (void)animationl;

@end
