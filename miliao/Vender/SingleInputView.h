//
//  SingleInputView.h
//  
//
//  Created by 张世浩 on 2017/12/2.
//  Copyright © 2017年 张世浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleInputView : UIView

/**
 SingleInputView 单行输入控件 灵活表单Type 0
 左边为标题 右边为选中内容，未输入时显示：请输入
 右边内容使用的UITextFiled
 */

//重写其set方法 设置左标题
@property (nonatomic,strong)NSString *nameStr;
//重写其set方法 设置左标题
@property (nonatomic,assign)NSInteger nameFont;

//重写set方法 设置内容的占位字符
@property (nonatomic,strong)NSString *placeholderStr;

//重写get方法,返回输入的值
@property (nonatomic,strong)NSString *reusltStr;

//左边标题的Label,外部可控制其相关属性。
@property (nonatomic,strong)UILabel *nameLabel;

//右边内容,外部可控制其相关属性。
@property (nonatomic,strong)UITextField *iTextField;

//是否为必填项的图标，默认隐藏，在部分场景下需要将其显示
@property (nonatomic,strong)UIImageView *icon;

//底部线
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic,strong)UIImageView *imageView1;

@property (nonatomic,strong)NSDictionary *dic;
/**
 通过重写其set方法，设置该控件的相关属性，如 是否可编辑 左标题文本 颜色 等等
 适用于客户拜访 设置控件的相关属性 和 选择内容的回显
 */
//@property(nonatomic,strong)BillDefineChild *model;

/**
 初始化方法
 
 @param type 1 整数型 2浮点型 3 为电话号码 不设置则为任意类型
 */
-(instancetype)initWithType:(NSInteger)type;
@end
