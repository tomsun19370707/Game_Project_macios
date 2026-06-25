//
//  DYActionSheet.h
//  GroupPurchaseProject
//
//  Created by 李东阳 on 2021/01/24.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYActionSheet : UIView
/** 初始化方法*/
- (instancetype)initWithTitleArr:(NSArray *)arr ;
/** 弹出*/
- (void)show;
/**
 点击事件说明
 index 是 -2的时候，是点击了空白处       消失弹框的
 index 是 -1的时候，是点击了取消按钮     消失弹框的
 */
@property (nonatomic,copy) void (^DActionSheetClick)(int index, NSString *title);
@end



