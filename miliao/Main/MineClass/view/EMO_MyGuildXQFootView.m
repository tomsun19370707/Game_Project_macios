//
//  EMO_MyGuildXQFootView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MyGuildXQFootView.h"

@interface EMO_MyGuildXQFootView()

Strong UIButton *getOutBtn;

Strong UIButton *chatBtn;

Strong UIButton *statusBtn;


@end

@implementation EMO_MyGuildXQFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self getOutBtn];
        [self chatBtn];
        [self statusBtn];
        self.getOutBtn.hidden=YES;
        self.chatBtn.hidden=YES;
        self.statusBtn.hidden=YES;
        
    }
    return self;
}

-(void)setStatus:(NSInteger)status{
    _status=status;
    if(status==3){
        self.getOutBtn.hidden=NO;
        self.chatBtn.hidden=YES;
        self.statusBtn.hidden=YES;
    }else if(status==4){
        self.getOutBtn.hidden=YES;
        self.chatBtn.hidden=YES;
        self.statusBtn.hidden=YES;
    }else{
        self.getOutBtn.hidden=YES;
        self.chatBtn.hidden=NO;
        self.statusBtn.hidden=NO;
        if (status==2){
            self.statusBtn.userInteractionEnabled=NO;
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,KAdaptedWidth(170),KAdaptedHeight(40));
            gl.startPoint = CGPointMake(0.5, 0);
            gl.endPoint = CGPointMake(0.5, 1);
            gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 0.5).CGColor];
            gl.locations = @[@(0.0),@(1.0f)];
            [_statusBtn.layer addSublayer:gl];
            [_statusBtn setTitle:getLanguage(@"申请签约中") forState:UIControlStateNormal];
            [_statusBtn setTitleColor:RGBA(51, 51, 51, 0.73) forState:UIControlStateNormal];
        }
        
    }


    
}


- (UIButton *)getOutBtn{
    if (!_getOutBtn) {
        _getOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getOutBtn.backgroundColor=RGBA(248, 248, 248, 1);
        [_getOutBtn setTitle:getLanguage(@"申请退会") forState:UIControlStateNormal];
        [_getOutBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _getOutBtn.titleLabel.font=KFontA(15);
        [_getOutBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _getOutBtn.tag=100;
        [self addSubview:_getOutBtn];
        [_getOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _getOutBtn;
}

- (UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setTitle:getLanguage(@"应聘咨询") forState:UIControlStateNormal];
        [_chatBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        _chatBtn.titleLabel.font=KFontA(15);
        [_chatBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.layer.borderColor=BaseMainColor.CGColor;
        _chatBtn.layer.borderWidth=1;
        _chatBtn.layer.cornerRadius=KAdaptedHeight(20);
        _chatBtn.layer.masksToBounds=YES;
        _chatBtn.tag=200;
        [self addSubview:_chatBtn];
        [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.width.mas_equalTo(KAdaptedWidth(170));
//            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.mas_equalTo(KAdaptedHeight(5));
            
        }];
    }
    return _chatBtn;
}

- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(170),KAdaptedHeight(40));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_statusBtn.layer addSublayer:gl];
        [_statusBtn setTitle:getLanguage(@"申请签约") forState:UIControlStateNormal];
        [_statusBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _statusBtn.titleLabel.font=KFontA(15);
        [_statusBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=KAdaptedHeight(20);
        _statusBtn.layer.masksToBounds=YES;
        _statusBtn.tag=300;
        [self addSubview:_statusBtn];
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(self.chatBtn.mas_height);
            make.width.mas_equalTo(self.chatBtn.mas_width);
            make.centerY.mas_equalTo(self.chatBtn.mas_centerY);
            
        }];
    }
    return _statusBtn;
}



-(void)BtnClick:(UIButton *)sender{
    
    if(self.BtnBlock){
        self.BtnBlock(sender.tag);
    }
}


@end
