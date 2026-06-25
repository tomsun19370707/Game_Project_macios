//
//  BaseController.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import "BaseController.h"

#import "Global.h"

@interface BaseController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseController

- (id)init{
    self = [super init];
    if (self) {
        
        [self initData];
    }
    return self;
}

- (void)initData{
    _uiStyle = [[BaseUIStyle alloc] init];
    _barView = nil;
    _titleLabel = nil;
    _leftButton = nil;
    _leftButtonView = nil;
    _leftTitleLabel = nil;
    _rightButton = nil;
    _rightButtonView = nil;
    _rightTitleLabel = nil;
    _isNeedLine = NO;
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    NSNotificationCenter *noCenter = [NSNotificationCenter defaultCenter];
    [noCenter addObserver:self selector:@selector(disableTimer) name:@"disableTimer" object:nil];
}

- (void)disableTimer{
    
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = _uiStyle.bgColor;
    self.navigationItem.hidesBackButton = YES;
    
    CGFloat width = ScreenViewWidth;
    CGFloat height = ScreenViewHeight;
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    _bgView.clipsToBounds = YES;
    [self clickTableViewHideKyeboard];
    
    [self.view addSubview:_bgView];
}

- (void)loadBar:(BOOL)needBar
       needBack:(BOOL)needBack
 needBackground:(BOOL)beedBackground{
    if (needBar) {
        CGFloat width = ScreenViewWidth;
        CGFloat barViewheight =  0;
        if (IS_IPHONE_NEWX) {
            barViewheight = _uiStyle.topBarHeight;
        }else{
            barViewheight =  _uiStyle.topBarHeight + ZJStatusBarH;
        }
   
        CGRect rect = CGRectMake(0.0f, 0.0f, width, barViewheight);
        _barView = [ControlCreator createView:_bgView rect:rect backguoundColor:_uiStyle.topBarBgColor];
        _barView.backgroundColor = [UIColor whiteColor];
        if (_isNeedLine) {
            UIView *line = [ControlCreator createView:_barView rect:CGRectMake(0, barViewheight, width, 0.5) backguoundColor:MLControlsHuiColor];
            [_barView addSubview:line];
        }
        
        // 标题
        CGFloat navHeight = KAdaptedHeight(44);
        CGFloat topMargin = self.barView.height - navHeight;
        width = self.view.width;
        rect = CGRectMake(0.0f,topMargin, width, navHeight);
        _titleLabel = [ControlCreator createLabel:_barView rect:rect text:nil font:_uiStyle.topBarTitleFont color:_uiStyle.topBarTitleColor backguoundColor:nil align:NSTextAlignmentCenter lines:0];
        
        // 左 - 按钮
        width = 120.0f;
        rect = CGRectMake(5.0f, topMargin, width, navHeight);
        if (needBack) {
            _leftButton = [ControlCreator createButton:_barView rect:rect text:nil font:nil color:nil backguoundColor:nil imageName:nil target:self action:@selector(backClick)];
        }else{
            _leftButton = [ControlCreator createButton:_barView rect:rect text:nil font:nil color:nil backguoundColor:nil imageName:nil target:nil action:nil];
        }
        
        
        // 左 标题
        CGFloat leftMargin = 10.0f;
        width = _leftButton.width - leftMargin;
        rect = CGRectMake(leftMargin, 0.0f, width, navHeight);
        _leftTitleLabel = [ControlCreator createLabel:_leftButton rect:rect text:nil font:_uiStyle.topBarButtionFont color:_uiStyle.topBarTitleColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:0];
        
        // 左 图标
        CGFloat backIconWidth = 20.0f;
        CGFloat backIconHeight = 20.0f;
        rect = CGRectMake((_leftButton.height - backIconWidth)*0.5f,_leftButton.height - 35, backIconWidth, backIconHeight);
        _leftButtonView.userInteractionEnabled = YES;
        _leftButtonView = [[UIImageView alloc] initWithFrame:rect];
        _leftButtonView.contentMode = UIViewContentModeCenter;
        _leftButtonView.backgroundColor = [UIColor clearColor];
        if (needBack) {
            _leftButtonView.image = [UIImage imageNamed:@"xiaoxi_back"];
        }
        [_leftButton addSubview:_leftButtonView];
        
        // 右 按钮
        CGFloat rightBtnWidth = _leftButton.width;
        CGFloat rightBtnHeight = _leftButton.height;
        rect = CGRectMake(ScreenViewWidth - rightBtnWidth - 5, topMargin, rightBtnWidth, rightBtnHeight);
        _rightButton = [ControlCreator createButton:_barView rect:rect text:nil font:nil color:nil backguoundColor:[UIColor clearColor] imageName:nil target:self action:@selector(rightButtonClick:)];
        
        //右 标题
        CGFloat rightTitleWidth = _rightButton.width - leftMargin;
        CGFloat rightTitleHeight = _rightButton.height;
        rect = CGRectMake(0.0f, 0.0f, rightTitleWidth, rightTitleHeight);
        _rightTitleLabel = [ControlCreator createLabel:_rightButton rect:rect text:nil font:_uiStyle.topBarButtionFont color:_uiStyle.topBarTitleColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentRight lines:0];
        _rightTitleLabel.adjustsFontSizeToFitWidth = YES;
        
        CGFloat rightIconWidth = _leftButtonView.width;
        CGFloat rightIconHeight = _leftButtonView.height;
        rect = CGRectMake(_rightButton.width - width - (_rightButton.height - rightIconWidth) * 0.5f, (_rightButton.height - rightIconHeight) * 0.5f, rightIconWidth, rightIconHeight);
        _rightButtonView = [[UIImageView alloc] initWithFrame:rect];
        _rightButtonView.contentMode = UIViewContentModeCenter;
        _rightButtonView.backgroundColor = [UIColor clearColor];
        [_rightButton addSubview:_rightButtonView];
        
    }
    if (beedBackground) {
        
    }
}

- (void)backClick{
    [self resignAllResponder];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)rightButtonClick:(UIButton *)sender{
    
}

- (void)resignFieldResponder{
    
}

- (void)resignOtherViewResponder{
    

}

- (void)resignAllResponder{
    [self resignFieldResponder];
    [self resignOtherViewResponder];
    
}

- (void)showMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
//取消键盘
-(void)clickTableViewHideKyeboard{
  
        UITapGestureRecognizer *gestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeboard)];
        gestureR.delegate = self;
        [self.view addGestureRecognizer:gestureR];
        
        gestureR.cancelsTouchesInView = NO;
    
    
    
}
- (void)hideKeboard{
  
  [self.view endEditing:YES];
  
}
- (void)reloadData{
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationWillEnterForeground" object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"applicationWillEnterForeground" object:nil];
//    self.hidesBottomBarWhenPushed=YES;
    
    
    if (self.navigationController) {
        /** 记录当前正在显示的控制器*/
        ObjectTool *set = [ObjectTool SharedSettings];
        set.currentVC = self ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
//    if (touch.view.width == ScreenViewWidth) {
//        return YES;
//    }
    
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"MLInputBoxView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"MLInputBoxView"]) {//

        return NO;

    }
    
    return YES;
    
}
//显示小红点
- (void)showBadge{
    //移除之前的小红点
    [self removeBadge];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.userInteractionEnabled = YES;
    badgeView.layer.cornerRadius = 2.5;//圆形
    badgeView.tag = 999;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    [self.rightButtonView addSubview:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButtonView.mas_right).offset(0);
        make.width.and.height.equalTo(@5);
        make.top.equalTo(self.rightButton.mas_top).offset(5);
    }];
}
//隐藏小红点
- (void)hideBadge{
    //移除小红点
    [self removeBadge];
}

//移除小红点
- (void)removeBadge{
    //按照tag值进行移除
    for (UIView *subView in self.rightButtonView.subviews) {
        if (subView.tag == 999) {
            [subView removeFromSuperview];
        }
    }
}
- (void)dealloc{
    NSNotificationCenter *noCenter = [NSNotificationCenter defaultCenter];
    [noCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
