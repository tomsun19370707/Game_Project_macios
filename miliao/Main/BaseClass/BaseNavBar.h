//
//  BaseNavBar.h
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    /** 适用于导航条为白色背景*/
    BaseNavBarTypeLightMode,
    /** 适用于导航条为深色背景，白色标题，返回键，移除导航条分割线*/
    BaseNavBarTypeDarkMode,
}BaseNavBarType;

/*
 自定义导航条
 */
@interface BaseNavBar : UIView
/** 左侧按钮，默认是返回键图片 */
@property (nonatomic,strong)UIImageView *leftImage;
/** 左侧点击 范围 button*/
@property (nonatomic,strong)UIButton *leftTouchBack;
/** 右侧单个点击按钮 */
@property (nonatomic,strong)UIButton *rightBarItem;
/** 左侧点击 */
@property (nonatomic,strong)NSArray <__kindof UIButton * > *leftBarItems;
/** 右侧点击 */
@property (nonatomic,strong)NSArray <__kindof UIButton * > *rightBarItems;
/** 导航标题 */
@property (nonatomic,strong)NSString *title;
/** 导航中心视图 */
@property (nonatomic,strong)UIView *titleView;
/** 是否显示导航栏底部的分割线 */
@property (nonatomic,assign)BOOL isShowCuttingLine;
/** 导航栏标题的文字颜色 */
@property (nonatomic,strong)UIColor *titleColor;
/** type*/
@property (nonatomic,assign) BaseNavBarType type;

/** 隐藏左侧按钮，包括点击事件 */
- (void)hideLeftBackButton:(BOOL)is;
@end

