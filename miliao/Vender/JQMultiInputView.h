//
//  MultiInputView.h
//  test
//
//  Created by 张世浩 on 16/11/15.
//  Copyright © 2016年 张世浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQMultiInputView : UIView

/**
 JQMultiInputView 多行输入控件 灵活表单Type 0
 左边为标题 右边为选中内容，未输入时显示：请输入
 右边内容使用的UITextView
 */

//左边标题的Label,外部可控制其相关属性。
@property(nonatomic,strong)UILabel *nameLabel;

//重写get方法,返回输入的值
@property(nonatomic,strong)UITextView *iTextView;

//重写get方法,返回输入的值
@property(nonatomic,strong)NSString *resultStr;

//重写其set方法 设置左标题
@property(nonatomic,strong)NSString *nameStr;

//重写set方法 设置内容的占位字符
@property(nonatomic,strong)NSString *placeholder;

//控件底部的线，默认隐藏，在该控件为最后一行时需要将其隐藏
@property(nonatomic,strong)UIView *lineView;

//显示占位字符的Label 在多行输入回显时需要手动将其隐藏
@property(nonatomic,strong)UILabel *placeholderLabel;

/**
 通过重写其set方法，设置该控件的相关属性，如 是否可编辑 左标题文本 颜色 等等
 适用于客户拜访 设置控件的相关属性 和 选择内容的回显
 */
//@property(nonatomic,strong)BillDefineChild *model;

//重写初始化方法，设置控件相关属性和功能
-(instancetype)init;
@end
