//
//  DYAlertView.m
//  doctorUser
//
//  Created by 李东阳 on 2019/3/12.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "DYAlertView.h"
#define  view_margin   20
/** view_width ,需要固定宽度，否则大屏会变形*/
#define  view_width  (320 - view_margin * 2)
/** 文字字号*/
#define  content_font_size   16
@interface DYAlertView ()
/** title*/
@property (nonatomic,strong) UILabel *titleLab;
/** content*/
@property (nonatomic,strong) UILabel *contntLab;
/** button*/
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
/** 分割线*/
@property (nonatomic,strong) UIImageView *line;
@end
@implementation DYAlertView

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel LabelWithFrame:CGRectMake(0, view_margin, view_width , 0) fontSize:18 textColor:[UIColor blackColor] textAlient:NSTextAlignmentCenter numberLines:1];
        _titleLab.backgroundColor = [UIColor whiteColor];
    }
    return _titleLab ; 
}
- (UILabel *)contntLab
{
    if (!_contntLab) {
        _contntLab = [UILabel LabelWithFrame:CGRectMake(view_margin, view_margin, view_width - view_margin * 2, 0) fontSize:content_font_size textColor:UIColorFromRGB(0x999999) textAlient:NSTextAlignmentCenter numberLines:1];
        _contntLab.backgroundColor = UIColor.clearColor;
        _contntLab.numberOfLines = 0 ;
    }
    return _contntLab ;
}
-(UIButton *)btn1
{
    if (!_btn1) {
        _btn1 = [UIButton racButtonWithTitle:nil BGImage:nil frame:CGRectMake(0, 0, view_width, 45) fontSize:content_font_size titleColor:UIColor.whiteColor];
        _btn1.backgroundColor = BaseMainColor ;
    }
    return _btn1 ;
}
-(UIButton *)btn2
{
    if (!_btn2) {
        _btn2 = [UIButton racButtonWithTitle:nil BGImage:nil frame:CGRectMake(0, 0, view_width, 45) fontSize:content_font_size titleColor:UIColorFromRGB(0x333333)];
        _btn2.backgroundColor = [UIColor whiteColor] ;
    }
    return _btn2 ;
}
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        /** 遮罩视图*/
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        //        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.multipleTouchEnabled = YES;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        //        [backgroundView addGestureRecognizer:tap];
        //        @weakify(self);
        //        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        //            @strongify(self);
        //            [self hideView];
        //        }];
        _maskView = backgroundView;
    }
    return _maskView ;
}
-(UIImageView *)line
{
    if (!_line) {
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view_width, 0.5)];
        line.backgroundColor = LineColor ;
        _line = line ;
    }
    return _line ;
}
#pragma mark --
#pragma mark --- implation method
/** 初始化方法*/
- (instancetype)initWithTitle:(NSString *)title  content:(NSString *)content construct:(NSString *)buttonName completion:(void(^)(void))completion;
{
    self = [super initWithFrame:CGRectMake(0, 0, view_width, 0)];
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES ;
    if (self) {
        CGFloat viewBottom = view_margin ;
        if (title) {
            [self addSubview:self.titleLab];
            self.titleLab.text = title ;
            [self.titleLab setHeight:20];
            viewBottom = self.titleLab.bottom + view_margin;
        }
        if (content) {
            [self addSubview:self.contntLab];
            self.contntLab.text = content;
            CGFloat tempHei = [NSString heightForContent:content font:self.contntLab.font contentWidth:self.contntLab.width] + 12 ;
            [self.contntLab setHeight:tempHei];
            [self.contntLab setTop:viewBottom];
            viewBottom = self.contntLab.bottom + view_margin;
        }
        
        /** 如果没有取消按钮，默认添加一个*/
        if (!buttonName || [buttonName isNull]) {
            buttonName = @"确定";
        }
        [self.btn1 setTitle:buttonName forState:UIControlStateNormal];
        [self.btn1 setTop:viewBottom];
        viewBottom = self.btn1.bottom ;
        @weakify(self);
        /** action*/
        [[self.btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hideView];
            if (completion) {
                completion();
            }
        }];
        
        [self addSubview:self.btn1];
        /** 分割线*/
        [self.line setTop:self.btn1.top];
        [self addSubview:self.line];
        /** height*/
        [self setHeight:viewBottom];
        [self setCenter:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
        /** 圆角*/
        self.layer.masksToBounds = YES ;
        self.layer.cornerRadius = 12 ;
    }
    return self ;
}
- (void)addButtonTitle:(NSString *)buttonName completion:(void(^)(void))completion
{
    if (buttonName) {
        [self.btn1 setLeft:view_width / 2];
        [self.btn1 setWidth:view_width / 2 ];
        
        [self.btn2 setTitle:buttonName forState:UIControlStateNormal];
        [self.btn2 setFrame:CGRectMake(0, self.btn1.top, self.btn1.width, self.btn1.height)];
        @weakify(self);
        /** action*/
        [[self.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hideView];
            if (completion) {
                completion();
            }
        }];
        [self addSubview:self.btn2];
    }
}
/** AttributedString*/
- (void)setContentAttr:(NSMutableAttributedString *)contentAttr
{
    if (contentAttr) {
        /** init*/
        if (!self.contntLab.text || [self.contntLab.text isNull]) {
            [self addSubview:self.contntLab];
        }
        /** text*/
        self.contntLab.attributedText = contentAttr;
        [self.contntLab setHeight:[NSString heightForContent:contentAttr.string font:self.contntLab.font contentWidth:self.contntLab.width]];
        [self.contntLab setTop:self.titleLab.bottom + view_margin];
        /** btn*/
        [self.btn1 setTop:self.contntLab.bottom + view_margin];
        /** btn2*/
        [self.btn2 setTop:self.btn1.top];
        /** 分割线*/
        [self.line setTop:self.btn1.top];
        /** height*/
        [self setHeight:self.btn1.bottom];
        [self setCenterY:SCREEN_HEIGHT / 2];
    }
}
- (void)show
{
    /** 避免DYAlertView多次弹框问题*/
    if ([ObjectTool SharedSettings].isAllowAlertShow) {
        [ObjectTool SharedSettings].isAllowAlertShow = NO ;
        [ObjectTool performSelectorAfterDelay:0.5 completion:^{
            [ObjectTool SharedSettings].isAllowAlertShow = YES ;
        }];
    }else{
        [self deallocSubview];
        return;
    }
    
    /** window*/
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /** 展示之前，先隐藏已经出现的弹框*/
    DYAlertView *tempV = [window viewWithTag:112914];
    if (tempV && [tempV isKindOfClass:[DYAlertView class]]) {
        [tempV hideView];
    }
    
    /** line */
    [self bringSubviewToFront:self.line];
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    /** 设置tag*/
    self.tag = 112914 ;
    
    /** 弹框动画*/
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:1.0];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [self.layer addAnimation:pulse forKey:nil];
}
- (void)hideView{
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(.3f, .3f);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self deallocSubview];
    }];
}
/** 销毁view*/
- (void)deallocSubview
{
    [_titleLab removeFromSuperview];
    [_contntLab removeFromSuperview];
    [_btn1 removeFromSuperview];
    [_btn2 removeFromSuperview];
    [_maskView removeFromSuperview];
    [_line removeFromSuperview];
    [self removeFromSuperview];
    _maskView.hidden = YES ;
}

@end




