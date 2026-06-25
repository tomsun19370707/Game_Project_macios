//
//  BaseController.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIStyle.h"


@interface BaseController : UIViewController

@property (nonatomic, strong) BaseUIStyle           *uiStyle;
@property (nonatomic, strong) UIView                *barView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIButton              *leftButton;
@property (nonatomic, strong) UIImageView           *leftButtonView;
@property (nonatomic, strong) UILabel               *leftTitleLabel;
@property (nonatomic, strong) UIButton              *rightButton;
@property (nonatomic, strong) UIImageView           *rightButtonView;
@property (nonatomic, strong) UILabel               *rightTitleLabel;
@property (nonatomic, strong) UIView                *bgView;
//@property (nonatomic, assign) BOOL                needBackground;
@property (nonatomic, assign) BOOL                isNeedLine;

- (void)loadBar:(BOOL)needBar needBack:(BOOL)needBack needBackground:(BOOL)beedBackground;
- (void)disableTimer;
- (void)backClick;
- (void)rightButtonClick:(UIButton *)sender;
- (void)showMessage:(NSString *)message;
- (void)reloadData;
- (void)hideKeboard;
//显示小红点
- (void)showBadge;
//隐藏小红点
- (void)hideBadge;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;
@end
