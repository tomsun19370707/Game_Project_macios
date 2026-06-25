//
//  CustomAlertView.m
//  SNKJ_PRO
//
//  Created by mac on 2020/9/4.
//  Copyright © 2020 Wang. All rights reserved.
//

#import "CustomAlertViewA.h"

#import "Masonry.h"
#import "UIView+Extensionss.h"
//#define ScreenWidth     ([[UIScreen mainScreen] bounds].size.width)
//#define ScreenHeight    ([[UIScreen mainScreen] bounds].size.height)
#define ScaleW(width)  width*ScreenWidth/375

@interface CustomAlertViewA()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIView *alertView;
@property (nonatomic ,strong) UIView *alertContentView;
@property (nonatomic ,assign) AlertType showType;
@property (nonatomic ,assign) ContentType contentType;
@property (nonatomic ,assign) CGFloat alertRadius;

@end


@implementation CustomAlertViewA


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled=YES;
         UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction)];
         [_bgView addGestureRecognizer:tap];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _bgView;
}

- (void) addChildrenViews{
    [self bgView];
    [self addSubview:self.alertView];
}

//设置内容
- (void)setAlertContentView:(UIView *)alertContentView{
    _alertContentView = alertContentView;
    [self.alertView addSubview:_alertContentView];
    [self layoutIfNeeded];
}
- (void)setShowType:(AlertType)showType{
    
    
    //如果在底部 防止键盘遮挡需要监听键盘
    
    if (showType == AlertType_Bottom) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillClose) name:UIKeyboardWillHideNotification object:nil];
    }

    _showType = showType;
    [self layoutIfNeeded];
}
- (void)setContentType:(ContentType)contentType{
    _contentType = contentType;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setUpView:self.showType];
    
    
    if (self.alertContentView) {
        [self.alertContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.showType == AlertType_Top) {
                //添加安全区域
                make.top.mas_equalTo(self.alertView).offset(44);
            }else{
                make.top.mas_equalTo(self.alertView);
            }
            make.leading.trailing.mas_equalTo(self.alertView);
            if (self.showType == AlertType_Meddle) {
                make.bottom.mas_equalTo(self.alertView);
            }else{
//                make.bottom.mas_equalTo(self.alertView).offset(-34);
                                make.bottom.mas_equalTo(self.alertView).offset(-DBottomDangerArea);
            }
            
        }];
    }
}


- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

//+(instancetype) showAlertView_Type:(AlertType)showType :(ContentType)contentType{

+(instancetype)showAlertView_Type:(AlertType)showType ContentType:(ContentType)contentType andData:(NSDictionary *)dic{
    CustomAlertViewA *customAlertView = [[CustomAlertViewA alloc] init];
    customAlertView.showType = showType;
    customAlertView.contentType = contentType;
    UIWindow *kwin = [UIApplication sharedApplication].keyWindow;
    customAlertView.frame = kwin.bounds;
    customAlertView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [kwin addSubview:customAlertView];
    customAlertView.alertRadius = 20;
    //设置内容
    [customAlertView setUpContentView:contentType andData:dic];
    //设置约束
    [customAlertView setUpView:showType];
    //执行动画
    [customAlertView startAnimat:showType];

    return customAlertView;
    
    
}

- (void) keyBoardWillShow{
    NSLog(@"键盘弹起");
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.y = ScreenHeight - self.alertView.bounds.size.height - ScaleW(240);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyBoardWillClose{
    NSLog(@"键盘收回");
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.y = ScreenHeight - self.alertView.height;
    } completion:^(BOOL finished) {
        
    }];
}




- (void) setUpContentView:(ContentType)contentType andData:(NSDictionary *)dataDic{
//    [self layoutIfNeeded];
    __weak typeof(self)weakSelf = self;
    if (contentType == DB_CustomContentViewTag) {
        DB_CustomContentView *content = [[DB_CustomContentView alloc] init];
        self.alertContentView = content;
        self.mytestContentView = content;
//        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData) {

            [weakSelf closeAnimation:weakSelf.showType];
        };
    }
    else if (contentType == BlessingBagCustomCententViewTag){
        BlessingBagCustomCententView *content = [[BlessingBagCustomCententView alloc] init];
        self.alertContentView = content;
        self.CustomFuDaiView = content;
        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData){
            
            [weakSelf closeAnimation:weakSelf.showType];
        };
        
        
        
    }
    else if (contentType == WinningRecordCustomViewTag){
        WinningRecordCustomView *content = [[WinningRecordCustomView alloc] init];
        self.alertContentView = content;
        self.CustomRecordView = content;
        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData) {
            
            [weakSelf closeAnimation:weakSelf.showType];
        };
        
    }
    else if (contentType == GiftDescriptionCustomViewTag){
        GiftDescriptionCustomView *content = [[GiftDescriptionCustomView alloc] init];
        self.alertContentView = content;
        self.CustomGiftView = content;
        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData){
            
            [weakSelf closeAnimation:weakSelf.showType];
        };
        
    }
    else if (contentType == AddTalkCustomViewTag){
        AddTalkCustomView *content = [[AddTalkCustomView alloc] init];
        self.alertContentView = content;
        self.CustomAddTalkView = content;
        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AddTalkNotification" object:nil userInfo:DicData]];
            [weakSelf closeAnimation:weakSelf.showType];
        };
        
    }
    else if (contentType == EMO_DBCustomRoomTypeViewTag){
        EMO_DBCustomRoomTypeView *content = [[EMO_DBCustomRoomTypeView alloc] init];
        self.alertContentView = content;
        self.customRoomTypeView = content;
        content.dicData=dataDic;
        content.cancleBtnClick = ^(NSDictionary * _Nonnull DicData) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"RoomTypeNotification" object:nil userInfo:DicData]];
            [weakSelf closeAnimation:weakSelf.showType];
        };
        
    }
    
    
}




-(void)concernAction{
    [self closeAnimation:self.showType];
}

- (void) closeAnimation:(AlertType)showType{
    CGFloat time = 0.2;
        if (self.showType == AlertType_Top) {
            [UIView animateWithDuration:time animations:^{
                self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                self.alertView.top = -self.alertView.bounds.size.height;
//                [self layoutIfNeeded];//强制绘制 才能执行masonry动画
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else if (self.showType == AlertType_Meddle){
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView animateWithDuration:time animations:^{
                self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                self.alertView.alpha = 0.0;
                self.alertView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                [self layoutIfNeeded];//强制绘制 才能执行masonry动画
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else{
            //底部 移除建瓯盘监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
            
            [UIView animateWithDuration:time animations:^{
                self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//                [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(self.mas_bottom);
//                }];
                self.alertView.top = self.alertView.superview.height;
                [self layoutIfNeeded];//强制绘制 才能执行masonry动画
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    
}

- (void)startAnimat:(AlertType)showType{
    
    [self layoutIfNeeded];
    CGFloat time = 0.2;
    
    if (self.showType == AlertType_Top) {
        [UIView animateWithDuration:time animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            self.alertView.top = 0;
//            [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(self.mas_top).offset(self.alertView.bounds.size.height);
//            }];
            [self layoutIfNeeded];//强制绘制 才能执行masonry动画
        } completion:^(BOOL finished) {
            
        }];
    }else if (self.showType == AlertType_Meddle){
        self.alertView.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:time animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            self.alertView.alpha = 1.0;
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self layoutIfNeeded];//强制绘制 才能执行masonry动画
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_bottom).offset(-self.alertView.bounds.size.height + Height_StatusBar);
            }];
            
            [self layoutIfNeeded];//强制绘制 才能执行masonry动画
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
    
    
}



- (void) setUpView : (AlertType)showType{
    //设置
    if (showType == AlertType_Top) {
        //顶部
       [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_top).offset(0);
        }];
        [self.alertView byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.alertRadius, self.alertRadius)];
    }else if (showType == AlertType_Meddle){
        //中间
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(ScaleW(-15));
            make.left.mas_equalTo(self).offset(ScaleW(15));
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
         [self.alertView byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.alertRadius, self.alertRadius)];
        self.alertView.layer.masksToBounds = YES;
    }else{
        //底部
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        [self.alertView byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(self.alertRadius, self.alertRadius)];
    }
}

@end
