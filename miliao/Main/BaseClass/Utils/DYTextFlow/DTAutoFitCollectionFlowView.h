//
//  DTAutoFitCollectionFlowView.h
//  ChatDemo-UI3.0
//
//  Created by 锤子科技 on 2017/9/21.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** 只显示所有内容*/
    DTAutoFitCollectionFlowViewTypeDefault,
    /** 突出显示选中的标签，类似添加购物车时弹框选择规格*/
    DTAutoFitCollectionFlowViewTypeFocusShow,
}DTAutoFitCollectionFlowViewType;

@interface DTAutoFitCollectionFlowView : UIView
/*
 自适应文字流，类似于任务标签形式
 传入NSString 类型 数组，自动展示布局
 */

//可选
/** 字体大小，文字高度也是根据字体来自适应的*/
@property (nonatomic,assign) CGFloat fontCusSize; /** 文字大小*/
@property (nonatomic,strong)UIColor *textColor; /** 文字颜色*/
@property (nonatomic,strong)UIColor *flowBGColor; /** 文字背景颜色*/
@property (nonatomic,assign) CGFloat Radius; /** 圆角大小，默认是一半圆角 */
@property (nonatomic,assign) BOOL isBorder; /** 是否有边框 */
@property (nonatomic,strong) UIColor *borderColor;; /** 边框颜色，默认是lineColor */
/** 文字控件本身的宽高增加的间距，默认是0*/
@property (nonatomic,assign) CGFloat WHMarginTemp;
/** 文字控件之间增加的左右和上下间距，默认是0*/
@property (nonatomic,assign) CGFloat WHMarginNeighborTemp;
/** type=DTAutoFitCollectionFlowViewTypeFocusShow 传入，选中item的颜色，字体以及文字颜色*/
@property (nonatomic,strong) UIColor *selectColor;

//可选
@property (nonatomic,assign) DTAutoFitCollectionFlowViewType type;

//必选
@property (nonatomic,strong)NSArray <__kindof NSString *> * dataArr;
/** 点击事件*/
@property (nonatomic,copy) void (^itemClickIndex)(NSUInteger index);
/** 设置选中index*/
@property (nonatomic,assign) NSUInteger setIndex;
@end



/**
 //使用方法
 -(DTAutoFitCollectionFlowView *)pin
 {
     if (!_pin) {
         _pin = [[DTAutoFitCollectionFlowView alloc]initWithFrame:CGRectMake(16, self.title.bottom + 5, SCREEN_WIDTH - 12 * 2 - 16 * 2, 10)];
         _pin.WHMarginTemp = 6 ;
         _pin.textColor = UIColorFromRGB(0x999999);
         _pin.isBorder = YES ;
         _pin.borderColor = UIColor.whiteColor ;
         _pin.WHMarginTemp = 12 ;
         _pin.WHMarginNeighborTemp = 8 ;
         _pin.flowBGColor = UIColor.whiteColor ;
         _pin.selectColor = BaseMainColor;
         _pin.Radius = 5 ;
         _pin.type = DTAutoFitCollectionFlowViewTypeFocusShow ;
     }
     return _pin ;
 }

 [self.pin setFrame:CGRectMake(16, 160, SCREEN_WIDTH - 16 * 2, 1)];
 self.pin.dataArr = @[@"不杀",@"杀"];
 [self.contentView addSubview:self.pin];

 */



