//
//  DYSingleListPicker.h
//  YingPu
//
//  Created by 李东阳 on 2018/10/19.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DYSingleListPicker : UIView
/** 可选 title*/
@property (nonatomic,strong) NSString *actionTitle;
/** 默认选中的index，可选，默认0*/
@property (nonatomic,assign) NSUInteger defIndex;
//必选
@property (nonatomic,strong)NSMutableArray <__kindof NSString *> * dataArr;
/** 点确定时候，触发该方法*/
@property (nonatomic,copy) void (^pickerSelectHandle)(NSUInteger index,NSString *title);
- (void)show;
@end
