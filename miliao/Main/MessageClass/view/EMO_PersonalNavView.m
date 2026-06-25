//
//  EMO_PersonalNavView.m
//  miliao
//
//  Created by 张世浩 on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalNavView.h"

@interface EMO_PersonalNavView()

Strong UIButton *BackBtn;


@end

@implementation EMO_PersonalNavView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.backgroundColor=[UIColor clearColor];
        [self BackBtn];
        [self messageBtn];
        [self moreBtn];
        
    }
    return self;
}

- (UIButton *)BackBtn{
    if (!_BackBtn) {
        _BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BackBtn setImage:[UIImage imageNamed:@"FZCX_BackW"] forState:UIControlStateNormal];
        [_BackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _BackBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _BackBtn.tag=100;
        [self addSubview:_BackBtn];
        [_BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJStatusBarH);
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            
        }];
//        [_BackBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _BackBtn;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"moreBtnImg"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _moreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _moreBtn.tag=300;
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.BackBtn.mas_top);
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(50));
            
        }];
//        [_messageBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _moreBtn;
}




- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"MessageImg"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _messageBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _messageBtn.tag=200;
        [self addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.BackBtn.mas_top);
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.trailing.mas_equalTo(self.moreBtn.mas_leading).offset(KAdaptedWidth(10));
            make.height.mas_equalTo(KAdaptedHeight(50));
            
        }];
//        [_messageBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _messageBtn;
}



-(void)btnClick:(UIButton *)sender{
    
    if(self.BtnBlock){
        self.BtnBlock(sender.tag);
    }
    
    
}





@end
