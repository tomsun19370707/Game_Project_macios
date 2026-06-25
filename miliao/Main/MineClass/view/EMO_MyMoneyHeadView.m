//
//  EMO_MyMoneyHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MyMoneyHeadView.h"

@interface EMO_MyMoneyHeadView ()
Strong UIView *bgView;
Strong UIImageView *bgImgView;
Strong UILabel *titleLabel;

Strong UIButton *subgiftBtn;
Strong UIButton *rechargeBtn;

Strong UILabel *tipLabel;

@end

@implementation EMO_MyMoneyHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= RGBA(255, 255, 255, 1);
    }
    return self;
}
- (void)initView{
    [self bgView];
    [self bgImgView];
    [self titleLabel];
    [self moneyLabel];
    [self rechargeBtn];
    [self subgiftBtn];
    
}


-(void)setType:(NSInteger)type{
    _type=type;
    if(type==1){
        if([[UserManager userInfo].is_transfer integerValue]!=1){
            self.subgiftBtn.hidden=YES;
        }
        self.moneyLabel.text=[UserManager userInfo].money;
        self.bgImgView.image=KGetImage(@"coinBgImg");
        self.titleLabel.text =getLanguage(@"金币钱包");
        self.titleLabel.textColor = RGBA(91, 61, 32, 1);
        self.moneyLabel.textColor = RGBA(91, 61, 32, 1);
        [self.rechargeBtn setTitle:getLanguage(@"充值") forState:UIControlStateNormal];
        [self.rechargeBtn setTitleColor:RGBA(209, 113, 0, 1) forState:UIControlStateNormal];
        [self.subgiftBtn setTitle:getLanguage(@"转赠") forState:UIControlStateNormal];
        [self.subgiftBtn setTitleColor:RGBA(209, 113, 0, 1) forState:UIControlStateNormal];
    }else{
        self.moneyLabel.text=[UserManager userInfo].diamond;
        self.bgImgView.image=KGetImage(@"zuanBgImg");
        self.titleLabel.text =getLanguage(@"钻石钱包");
        self.titleLabel.textColor = RGB(255, 255, 255);
        self.moneyLabel.textColor = RGB(255, 255, 255);
        [self.rechargeBtn setTitle:getLanguage(@"提现") forState:UIControlStateNormal];
        [self.rechargeBtn setTitleColor:RGBA(61, 35, 133, 1) forState:UIControlStateNormal];
        [self.subgiftBtn setTitle:getLanguage(@"明细") forState:UIControlStateNormal];
        [self.subgiftBtn setTitleColor:RGBA(61, 35, 133, 1) forState:UIControlStateNormal];
    }
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.height.mas_equalTo(KAdaptedHeight(120));
        }];
    }
    return _bgView;
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"WalletBgImg");
        [self.bgView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _bgImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text =getLanguage(@"金币钱包");
        _titleLabel.textColor = RGB(255, 255, 255);
        _titleLabel.font = KFont(13);
        _titleLabel.numberOfLines=0;
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_top).offset(KAdaptedHeight(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedWidth(20));
            make.height.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text =getLanguage(@"0.00");
        _moneyLabel.textColor = RGB(255, 255, 255);
        _moneyLabel.font = KFontBold(20);
        _moneyLabel.numberOfLines=0;
        _moneyLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.leading.mas_equalTo(self.titleLabel.mas_leading).offset(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _moneyLabel;
}


- (UIButton *)subgiftBtn{
    if (!_subgiftBtn) {
        _subgiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subgiftBtn.backgroundColor=RGBA(255, 255, 255, 1);
        [_subgiftBtn setTitle:getLanguage(@"转赠") forState:UIControlStateNormal];
        [_subgiftBtn setTitleColor:RGBA(55, 171, 255, 1) forState:UIControlStateNormal];
        _subgiftBtn.titleLabel.font=KFont(15);
        _subgiftBtn.layer.cornerRadius=KAdaptedHeight(15);
        _subgiftBtn.layer.masksToBounds=YES;
        _subgiftBtn.tag=100;
        [_subgiftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_subgiftBtn];
        [_subgiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.mas_equalTo(self.rechargeBtn.mas_leading).offset(KAdaptedWidth(-15));
            make.leading.mas_equalTo(self.rechargeBtn.mas_trailing).offset(KAdaptedWidth(15));
            make.centerY.mas_equalTo(self.rechargeBtn.mas_centerY);
            make.width.mas_equalTo(self.rechargeBtn.mas_width);
            make.height.mas_equalTo(self.rechargeBtn.mas_height);
            
        }];
    }
    return _subgiftBtn;
}


- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.backgroundColor=RGBA(255, 255, 255, 1);
        [_rechargeBtn setTitle:getLanguage(@"充值") forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:RGBA(55, 171, 255, 1) forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font=KFont(15);
        _rechargeBtn.layer.cornerRadius=KAdaptedHeight(15);
        _rechargeBtn.layer.masksToBounds=YES;
        _rechargeBtn.tag=200;
        [_rechargeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_rechargeBtn];
        [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.mas_equalTo(KAdaptedWidth(-20.5));
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(-8));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(68), KAdaptedHeight(30)));
            
        }];
    }
    return _rechargeBtn;
}

-(void)BtnClick:(UIButton *)sender{
    if (self.BtnBlick) {
        self.BtnBlick(sender.tag);
    }
    
}


@end
