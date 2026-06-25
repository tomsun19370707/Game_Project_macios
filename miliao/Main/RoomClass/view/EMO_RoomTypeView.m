//
//  EMO_RoomTypeView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RoomTypeView.h"
#import "EMO_BtnView.h"
@interface EMO_RoomTypeView ()
Strong UIView  *bgView;
//Strong UIImageView *bgImgView;
Strong UIView  *conentbgView;

Strong UIButton *friendBtn;
Strong UIButton *emotionBtn;
Strong UIButton *radioBtn;
Strong UIView *lineView;

Strong UIView  *bottombgView;

Assign NSInteger selectBtn;

@end


@implementation EMO_RoomTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

-(void)initView{
    [self bgView];
//    [self bgImgView];
    [self conentbgView];
    [self friendBtn];
    [self emotionBtn];
    [self radioBtn];
    [self lineView];
    [self bottombgView];
    self.selectBtn=100;
    [self addData];
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGBA(51, 51, 51, 0.3);
        _bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _bgView;
}


//- (UIImageView*)bgImgView{
//    if (!_bgImgView) {
//        _bgImgView = [[UIImageView alloc] init];
////        _bgImgView.image=KGetImage(@"roomSettingBgimg");
//        _bgImgView.backgroundColor=RGBA(255, 255, 255, 1);
//        [self addSubview:_bgImgView];
//        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
//            make.height.mas_equalTo(KAdaptedHeight(150));
//            make.bottom.mas_equalTo(KAdaptedHeight(15));
//        }];
//        setViewCorner(_bgImgView, KAdaptedHeight(15));
//    }
//    return _bgImgView;
//}

- (UIView *)conentbgView{
    if (!_conentbgView) {
        _conentbgView = [[UIView alloc] init];
        _conentbgView.backgroundColor = RGBA(255, 255, 255, 1);
        [self addSubview:_conentbgView];
        [_conentbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(150));
            make.bottom.mas_equalTo(KAdaptedHeight(15));
        }];
        setViewCorner(_conentbgView, KAdaptedHeight(15));
        }
    return _conentbgView;
}




- (UIButton *)friendBtn{
    if (!_friendBtn) {
        _friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_friendBtn setTitle:getLanguage(@"交友") forState:UIControlStateNormal];
        [_friendBtn setTitle:getLanguage(@"交友") forState:UIControlStateSelected];
        [_friendBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [_friendBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateSelected];
        _friendBtn.titleLabel.font=KFontA(17);
        _friendBtn.selected=YES;
//        _friendBtn.titleLabel.font=KFontA(14);
        [_friendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _friendBtn.tag=100;
        [self.conentbgView addSubview:_friendBtn];
        [_friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedWidth(30));
        }];
    }
    return _friendBtn;
}

- (UIButton *)emotionBtn{
    if (!_emotionBtn) {
        _emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emotionBtn setTitle:getLanguage(@"情感") forState:UIControlStateNormal];
        [_emotionBtn setTitle:getLanguage(@"情感") forState:UIControlStateSelected];
        [_emotionBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [_emotionBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateSelected];
        _emotionBtn.titleLabel.font=KFontA(14);
        [_emotionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _emotionBtn.tag=200;
        [self.conentbgView addSubview:_emotionBtn];
        [_emotionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.friendBtn.mas_top);
            make.width.mas_equalTo(self.friendBtn.mas_width);
            make.height.mas_equalTo(self.friendBtn.mas_height);
            make.leading.mas_equalTo(self.friendBtn.mas_trailing).offset(KAdaptedWidth(20));
        }];
    }
    return _emotionBtn;
}
- (UIButton *)radioBtn{
    if (!_radioBtn) {
        _radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_radioBtn setTitle:getLanguage(@"电台") forState:UIControlStateNormal];
        [_radioBtn setTitle:getLanguage(@"电台") forState:UIControlStateSelected];
        [_radioBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [_radioBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateSelected];
        _radioBtn.titleLabel.font=KFontA(14);
        [_radioBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _radioBtn.tag=300;
        [self.conentbgView addSubview:_radioBtn];
        [_radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.friendBtn.mas_top);
            make.width.mas_equalTo(self.friendBtn.mas_width);
            make.height.mas_equalTo(self.friendBtn.mas_height);
            make.leading.mas_equalTo(self.emotionBtn.mas_trailing).offset(KAdaptedWidth(20));
        }];
    }
    return _radioBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame=CGRectMake(KAdaptedWidth(15), KAdaptedHeight(35), KAdaptedWidth(30), KAdaptedHeight(4));
        _lineView.backgroundColor = RGBA(255,198, 0, 1);
        [self.conentbgView addSubview:_lineView];
        setViewCorner(_lineView, KAdaptedHeight(2));
    }
    return _lineView;
}

- (UIView *)bottombgView{
    if (!_bottombgView) {
        _bottombgView = [[UIView alloc] init];
        _bottombgView.backgroundColor = kWhiteColor;
        [self addSubview:_bottombgView];
        [_bottombgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.friendBtn.mas_bottom);
            make.bottom.leading.trailing.mas_equalTo(0);
        }];
    }
    return _bottombgView;
}



-(void)btnClick:(UIButton *)sender{
  
    
    for (UIButton *btn in self.conentbgView.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            if(btn.tag==sender.tag){
                btn.selected=YES;
                btn.titleLabel.font=KFontA(17);
                [UIView animateWithDuration:0.1 animations:^{
                    self.lineView.frame=CGRectMake(KAdaptedWidth(30)+KAdaptedWidth(80)*(btn.tag/100-1),KAdaptedHeight(35), KAdaptedWidth(30), KAdaptedHeight(4));
                }];
            }else{
                btn.selected=NO;
                btn.titleLabel.font=KFontA(14);
            }
            
        }
    }
    self.selectBtn=sender.tag;
    [self.bottombgView removeAllSubviews];
    [self addData];
    
    
}


-(void)addData{
    
    for (int i=0; i<arc4random()%4+1; i++) {
        EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
        gamrBtn.iconImgView.image=KGetImage(@"partitionImg");
        gamrBtn.nameLabel.text=@"交友";
        gamrBtn.ClickBtn.tag=100+i;
        WeakSelf;
        gamrBtn.BtnBlock = ^(NSInteger tag) {
            [wself SettingBtnClick:tag];
        };
        [self.bottombgView addSubview:gamrBtn];
        [gamrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedHeight(75));
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(KAdaptedWidth(20)+(KAdaptedWidth(70))*i);
            
        }];
        
        
        
    }
    
    
}




-(void)SettingBtnClick:(NSInteger )tag{
    if(self.BtnClick){
        self.BtnClick(self.selectBtn,tag);
    }
    
}



@end
