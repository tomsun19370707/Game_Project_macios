//
//  DYAlertView.h
//  doctorUser
//
//  Created by 李东阳 on 2019/3/12.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 仿照系统alertView弹框,最多两个点击button*/
@interface DYAlertView : UIView
/** 初始化方法,buttonName不设置默认 “确定” */
- (instancetype)initWithTitle:(NSString *)title  content:(NSString *)content construct:(NSString *)buttonName completion:(void(^)(void))completion;
- (void)addButtonTitle:(NSString *)buttonName completion:(void(^)(void))completion;
/** AttributedString*/
- (void)setContentAttr:(NSMutableAttributedString *)contentAttr;
- (void)show;

@end

