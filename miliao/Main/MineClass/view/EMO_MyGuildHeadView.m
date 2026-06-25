//
//  EMO_MyGuildHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/18.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MyGuildHeadView.h"

@interface EMO_MyGuildHeadView()


Strong UIImageView *bgImgVIiew;
Strong UIImageView *topImgVIew;
Strong UIImageView *titleImgVIew;


Strong UIView *settingView;
Strong UIImageView *settingImgVIew;
Strong UILabel *settingLabel;
Strong UIButton *settingBtn;

Strong UIView *invitationView;
Strong UIImageView *invitationImgVIew;
Strong UILabel *invitationLabel;
Strong UIButton *invitationBtn;

Strong UIView *bgBottomVIiew;

@end


@implementation EMO_MyGuildHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= RGBA(248, 248, 248, 1);
    
    }
    return self;
}

- (void)initView{
    [self  bgImgVIiew];
    [self titleImgVIew];
    [self topImgVIew];
    [self settingView];
    [self settingImgVIew];
    [self settingLabel];
    [self settingBtn];
    [self invitationView];
    [self invitationImgVIew];
    [self invitationLabel];
    [self invitationBtn];
    [self bgBottomVIiew];
    
}


- (UIImageView*)bgImgVIiew{
    if (!_bgImgVIiew) {
        _bgImgVIiew = [[UIImageView alloc] init];
        _bgImgVIiew.image=KGetImage(@"familyBgImg");
        [self addSubview:_bgImgVIiew];
        [_bgImgVIiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _bgImgVIiew;
}

- (UIImageView*)topImgVIew{
    if (!_topImgVIew) {
        _topImgVIew = [[UIImageView alloc] init];
        _topImgVIew.image=KGetImage(@"familySearchImg");
        _topImgVIew.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction)];
        [_topImgVIew addGestureRecognizer:tap];
        [self addSubview:_topImgVIew];
        [_topImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-50));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(50)));
            make.centerY.mas_equalTo(self.titleImgVIew.mas_centerY).offset(KAdaptedHeight(-10));
          
        }];
    }
    return _topImgVIew;
}

- (UIImageView*)titleImgVIew{
    if (!_titleImgVIew) {
        _titleImgVIew = [[UIImageView alloc] init];
        _titleImgVIew.image=KGetImage(@"familyTitleImg");
        [self addSubview:_titleImgVIew];
        [_titleImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.topImgVIew.mas_bottom).offset(KAdaptedHeight(20));
            make.bottom.mas_equalTo(KAdaptedHeight(-120));
            make.leading.mas_equalTo(KAdaptedWidth(20));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(170), KAdaptedHeight(35)));
        }];
    }
    return _titleImgVIew;
}

- (UIView *)settingView{
    if (!_settingView) {
        _settingView = [[UIView alloc] init];
        _settingView.backgroundColor=RGBA(228, 240, 255, 1);
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(145),KAdaptedHeight(60));
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:210/255.0 green:238/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:250/255.0 green:253/255.0 blue:255/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_settingView.layer addSublayer:gl];
        _settingView.layer.cornerRadius = KAdaptedHeight(10);
        _settingView.layer.masksToBounds=YES;
        [self addSubview:_settingView];
        [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(165), KAdaptedHeight(65)));
            make.top.mas_equalTo(self.titleImgVIew.mas_bottom).offset(KAdaptedHeight(25));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            
        }];
    }
    return _settingView;
}


- (UIImageView*)settingImgVIew{
    if (!_settingImgVIew) {
        _settingImgVIew = [[UIImageView alloc] init];
        _settingImgVIew.image=KGetImage(@"familyEquityImg");
        [self.settingView addSubview:_settingImgVIew];
        [_settingImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(60));
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(10));
            
        }];
    }
    return _settingImgVIew;
}

- (UILabel *)settingLabel{
    if (!_settingLabel) {
        _settingLabel = [[UILabel alloc] init];
        _settingLabel.text = getLanguage(@"家族权益");
        _settingLabel.textColor = RGBA(51, 51, 51, 1);
        _settingLabel.font=KFont(14);
        [self.settingView addSubview:_settingLabel];
        [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.settingImgVIew.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.top.bottom.mas_equalTo(KAdaptedWidth(0));
            
        }];
    }
    return _settingLabel;
}


- (UIButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.tag=100;
        [self.settingView addSubview:_settingBtn];
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _settingBtn;
}





- (UIView *)invitationView{
    if (!_invitationView) {
        _invitationView = [[UIView alloc] init];
        _invitationView.backgroundColor=RGBA(228, 240, 255, 1);
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(145),KAdaptedHeight(60));
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:210/255.0 green:238/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:250/255.0 green:253/255.0 blue:255/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_invitationView.layer addSublayer:gl];
        _invitationView.layer.cornerRadius = KAdaptedHeight(10);
        _invitationView.layer.masksToBounds=YES;
        [self addSubview:_invitationView];
        [_invitationView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(self.settingView.mas_width);
            make.height.mas_equalTo(self.settingView.mas_height);
            make.centerY.mas_equalTo(self.settingView.mas_centerY);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
    }
    return _invitationView;
}


- (UIImageView*)invitationImgVIew{
    if (!_invitationImgVIew) {
        _invitationImgVIew = [[UIImageView alloc] init];
        _invitationImgVIew.image=KGetImage(@"familyguideImg");
        [self.invitationView addSubview:_invitationImgVIew];
        [_invitationImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(60));
            make.centerY.mas_equalTo(KAdaptedHeight(6));
            make.leading.mas_equalTo(KAdaptedWidth(15));
        }];
    }
    return _invitationImgVIew;
}

- (UILabel *)invitationLabel{
    if (!_invitationLabel) {
        _invitationLabel = [[UILabel alloc] init];
        _invitationLabel.text = getLanguage(@"家族指引");
        _invitationLabel.textColor = RGBA(51, 51, 51, 1);
        _invitationLabel.font=KFont(14);
        [self.invitationView addSubview:_invitationLabel];
        [_invitationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.invitationImgVIew.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.top.bottom.mas_equalTo(KAdaptedWidth(0));
            
        }];
    }
    return _invitationLabel;
}


- (UIButton *)invitationBtn{
    if (!_invitationBtn) {
        _invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_invitationBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _invitationBtn.tag=200;
        [self.invitationView addSubview:_invitationBtn];
        [_invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _invitationBtn;
}



- (UIView *)bgBottomVIiew{
    if (!_bgBottomVIiew) {
        _bgBottomVIiew = [[UIView alloc] init];
        _bgBottomVIiew.backgroundColor = [UIColor whiteColor];
        _bgBottomVIiew.layer.masksToBounds=YES;
        _bgBottomVIiew.layer.cornerRadius=KAdaptedHeight(10);
        [self addSubview:_bgBottomVIiew];
        [_bgBottomVIiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.width.mas_equalTo(kWidth);
            make.bottom.mas_equalTo(KAdaptedHeight(20));
        
        }];
    }
    return _bgBottomVIiew;
}


-(void)concernAction{
    if (self.BtnBlock) {
        self.BtnBlock(888);
    }
}

-(void)BtnClick:(UIButton *)sendwr{
    
    if (self.BtnBlock) {
        self.BtnBlock(sendwr.tag);
    }
    
    
}



@end
