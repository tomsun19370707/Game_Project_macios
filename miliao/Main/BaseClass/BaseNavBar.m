//
//  BaseNavBar.m
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "BaseNavBar.h"
/** 导航条所有控件中心 Y值*/
#define  kCenterY        (IS_iPhoneX ?  (24.f + 64.f / 2 + 10)  :  (64.f / 2 + 10))
@interface BaseNavBar ()
/** 导航栏标题*/
@property (nonatomic,strong) UILabel *navTitle;
/** 导航栏 上分割线*/
@property (nonatomic,strong) UIImageView *line;
@end

@implementation BaseNavBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 页面*/
        [self initContentView];
    }
    return self ;
}
#pragma mark --- 初始化
- (void)initContentView
{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight);
    self.frame = rect ;
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES ;
    self.backgroundColor  = [UIColor whiteColor];
    
    /** 导航标题初始化*/
    [self addSubview:self.navTitle];
    /** 左侧返回键图片*/
    [self addSubview:self.leftImage];
    /** 左侧返回键点击button，目的是增加点击范围*/
    [self addSubview:self.leftTouchBack];
    /** 分割线*/
    [self addSubview:self.line];
}
#pragma mark --- 设置右侧单个按钮
- (void)setRightBarItem:(UIButton *)rightBarItem
{
    if (!rightBarItem) {
        return ;
    }
    [rightBarItem setFrame:CGRectMake(0, 0, rightBarItem.width, rightBarItem.height)];
    [rightBarItem setRight:SCREEN_WIDTH - 15];
    [rightBarItem setCenterY:kCenterY];
    [self addSubview:rightBarItem];
}
#pragma mark --- 左侧按钮 组
- (void)setLeftBarItems:(NSArray *)leftBarItems
{
    if (leftBarItems.count == 0) {
        return ;
    }
    
    [self hideLeftBackButton:YES] ;
    
    UIButton *btnTemp = leftBarItems[0];
    
    CGFloat margin = btnTemp.width + 20 ;
    for (int i = 0; i < leftBarItems.count ; i ++) {
        UIButton *btn = leftBarItems[i];
        [btn setFrame:CGRectMake(0, 0, btn.width, btn.height)];
        [btn setLeft:15 + i * margin ];
        [btn setCenterY:kCenterY];
        [self addSubview:btn];
    }
}
#pragma mark --- 右侧按钮 组
- (void)setRightBarItems:(NSArray *)rightBarItems
{
    if (rightBarItems.count == 0) {
        return ;
    }
    
    UIButton *btnTemp = rightBarItems[0];
    
    CGFloat margin = btnTemp.width + 20 ;
    for (int i = 0; i < rightBarItems.count ; i ++) {
        UIButton *btn = rightBarItems[i];
        [btn setFrame:CGRectMake(0, 0, btn.width, btn.height)];
        [btn setRight:SCREEN_WIDTH - 15 - i * margin ];
        [btn setCenterY:kCenterY];
        [self addSubview:btn];
    }
}
#pragma mark --- 设置导航标题
- (void)setTitle:(NSString *)title
{
    self.navTitle.text = title ;
}
#pragma mark --- 是否展示分割线
-(void)setIsShowCuttingLine:(BOOL)isShowCuttingLine
{
    _line.hidden = !isShowCuttingLine ;
}
#pragma mark --- 设置titleView
- (void)setTitleView:(UIView *)titleView
{
    [titleView setCenterX:SCREEN_WIDTH / 2 ];
    [titleView setCenterY:kCenterY];
    
    [self addSubview:titleView ];
}
#pragma mark --
#pragma mark --- type
-(void)setType:(BaseNavBarType)type
{
    if (type == BaseNavBarTypeDarkMode) {
        self.leftImage.image = IMAGE(@"back_btn_white");
        [self setIsShowCuttingLine:NO] ;
        [self setTitleColor:UIColor.whiteColor] ;
    }else{
        self.leftImage.image = IMAGE(@"back_btn_black");
        [self setIsShowCuttingLine:YES] ;
        [self setTitleColor:UIColor.blackColor] ;
    }
}

#pragma mark --- 隐藏左侧点击和对应的图片
- (void)hideLeftBackButton:(BOOL)is
{
    _leftImage.hidden = is;
    self.leftTouchBack.hidden = is ;
}
#pragma mark --- 设置导航标题颜色
- (void)setTitleColor:(UIColor *)titleColor
{
    self.navTitle.textColor = titleColor ;
}
- (UILabel *)navTitle
{
    if (!_navTitle) {
        _navTitle = [UILabel LabelWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 40 * 2, 30) fontSize:1 textColor:[UIColor blackColor] textAlient:NSTextAlignmentCenter numberLines:1];
        [_navTitle setCenterY:kCenterY];
        _navTitle.font = [UIFont boldSystemFontOfSize:18];
        _navTitle.userInteractionEnabled = YES;
        _navTitle.multipleTouchEnabled = YES ;
    }
    return _navTitle ;
}
-(UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc]initWithFrame: CGRectMake(15, 0, 18, 18)];
        [_leftImage setCenterY:kCenterY];
        _leftImage.userInteractionEnabled = YES;
        _leftImage.multipleTouchEnabled = YES ;
        _leftImage.image = IMAGE(@"back_btn_black");
    }
    return _leftImage ;
}
-(UIButton *)leftTouchBack
{
    if (!_leftTouchBack) {
        self.leftTouchBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [self.leftTouchBack setCenterY:kCenterY];
        //        self.leftTouchBack.backgroundColor = [UIColor redColor];
    }
    return _leftTouchBack ;
}
-(UIImageView *)line
{
    if (!_line) {
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavBarHeight - 0.5, SCREEN_WIDTH,0.5)];
        _line.backgroundColor = LineColor;
    }
    return _line ;
}
@end

