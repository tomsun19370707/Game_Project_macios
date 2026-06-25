//
//  EMO_PaymentView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_PaymentView.h"
#import "EMO_payView.h"
@interface EMO_PaymentView()<YBAttributeTapActionDelegate>
Strong UIView *bgView;
Strong UILabel *titleLabel;
Strong EMO_payView *wechatPayView;
Strong EMO_payView *aliPayView;
Strong EMO_payView *otherPayView;


@end


@implementation EMO_PaymentView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= RGBA(255, 255, 255, 1);
        self.userInteractionEnabled=YES;
    }
    return self;
}


- (void)initView{
    [self bgView];
    [self titleLabel];
    [self wechatPayView];
    [self aliPayView];
    [self otherPayView];
    self.otherPayView.hidden=YES;

    
}

-(void)setType:(NSInteger)type{
    _type=type;
    
    if(type==1){
        _titleLabel.text = getLanguage(@"提现方式");
    }else{
        _titleLabel.text = getLanguage(@"支付方式");
    }
    
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(0);
            
        }];
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"支付方式");
        _titleLabel.textColor = RGBA(0, 0, 0, 1);
        _titleLabel.font=KFontBold(14);
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(13));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _titleLabel;
}



- (EMO_payView *)wechatPayView{
    if (!_wechatPayView) {
        _wechatPayView = [[EMO_payView alloc] init];
        _wechatPayView.backgroundColor = [UIColor whiteColor];
        _wechatPayView.layer.cornerRadius=KAdaptedHeight(10);
        _wechatPayView.layer.masksToBounds=YES;
        _wechatPayView.layer.borderColor=RGBA(248, 248, 248, 1).CGColor;
        _wechatPayView.layer.borderWidth=1;
        _wechatPayView.iconImgView.image=KGetImage(@"wechatPayImg");
        _wechatPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        _wechatPayView.nameLabel.text=getLanguage(@"微信支付");
        _wechatPayView.selectBtn.tag=1000;
        [_wechatPayView.selectBtn addTarget:self action:@selector(BtnXlick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_wechatPayView];
        [_wechatPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(12));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(55));

            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _wechatPayView;
}

- (EMO_payView *)aliPayView{
    if (!_aliPayView) {
        _aliPayView = [[EMO_payView alloc] init];
        _aliPayView.backgroundColor = [UIColor whiteColor];
        _aliPayView.layer.cornerRadius=KAdaptedHeight(10);
        _aliPayView.layer.masksToBounds=YES;
        _aliPayView.layer.borderColor=RGBA(248, 248, 248, 1).CGColor;
        _aliPayView.layer.borderWidth=1;
        _aliPayView.iconImgView.image=KGetImage(@"aliPayImg");
        _aliPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        _aliPayView.nameLabel.text=getLanguage(@"支付宝支付");
        _aliPayView.selectBtn.tag=2000;
        [_aliPayView.selectBtn addTarget:self action:@selector(BtnXlick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_aliPayView];
        [_aliPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.wechatPayView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.wechatPayView.mas_leading).offset(KAdaptedHeight(0));
            make.trailing.mas_equalTo(self.wechatPayView.mas_trailing).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(self.wechatPayView.mas_height).offset(KAdaptedHeight(0));
            
        }];
    }
    return _aliPayView;
}

- (EMO_payView *)otherPayView{
    if (!_otherPayView) {
        _otherPayView = [[EMO_payView alloc] init];
        _otherPayView.backgroundColor = [UIColor whiteColor];
        _otherPayView.layer.cornerRadius=KAdaptedHeight(10);
        _otherPayView.layer.masksToBounds=YES;
        _otherPayView.layer.borderColor=RGBA(248, 248, 248, 1).CGColor;
        _otherPayView.layer.borderWidth=1;
        _otherPayView.iconImgView.image=KGetImage(@"yuEImg");
        _otherPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        _otherPayView.nameLabel.text=getLanguage(@"第三方支付支付");
        _otherPayView.selectBtn.tag=3000;
        [_otherPayView.selectBtn addTarget:self action:@selector(BtnXlick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_otherPayView];
        [_otherPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.aliPayView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.wechatPayView.mas_leading).offset(KAdaptedHeight(0));
            make.trailing.mas_equalTo(self.wechatPayView.mas_trailing).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(self.wechatPayView.mas_height).offset(KAdaptedHeight(0));
        }];
    }
    return _otherPayView;
}


-(void)BtnXlick:(UIButton *)sender{
    if (sender.tag==1000) {
        self.wechatPayView.selectImgView.image=KGetImage(@"noticSelectImg");
        self.aliPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        self.otherPayView.selectImgView.image=KGetImage(@"noticNormalImg");
    }else if (sender.tag==2000){
        self.wechatPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        self.aliPayView.selectImgView.image=KGetImage(@"noticSelectImg");
        self.otherPayView.selectImgView.image=KGetImage(@"noticNormalImg");
    }else{
        self.wechatPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        self.aliPayView.selectImgView.image=KGetImage(@"noticNormalImg");
        self.otherPayView.selectImgView.image=KGetImage(@"noticSelectImg");
    }
    
    if (self.payTypeBlock) {
       self.payTypeBlock(sender.tag);
   }
    
//    self.PayType=sender.tag;
    
}

//
//-(void)BtnClick{
////    防止多次点击
//    self.buyBtn.userInteractionEnabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.buyBtn.userInteractionEnabled = YES;
//    });
//    if (self.PayType>0) {
//        if (self.payTypeBlock) {
//            self.payTypeBlock(self.PayType);
//        }
//    }else{
//        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请选择支付方式")];
//    }
//
//}
//
//









@end
