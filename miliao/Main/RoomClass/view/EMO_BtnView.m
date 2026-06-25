//
//  EMO_BtnView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/25.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_BtnView.h"

@interface EMO_BtnView()


@end


@implementation EMO_BtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];

        
    }
    return self;
}

-(void)initView{
    [self iconImgView];
    [self nameLabel];
    [self ClickBtn];
}

-(void)setImgTop:(NSInteger)imgTop{
    _imgTop=imgTop;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgTop);
        
    }];
    [self.iconImgView layoutIfNeeded];
    
}

-(void)setLabelBottom:(NSInteger)labelBottom{
    _labelBottom=labelBottom;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(labelBottom);
    }];
    [self.nameLabel layoutIfNeeded];
    
    
}


- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
//        _iconImgView.image=KGetImage(@"");
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(40));
//            make.leading.mas_equalTo(0);
//            make.trailing.mas_equalTo(0);
//            make.bottom.mas_equalTo(-KAdaptedHeight(50));
            
        }];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.numberOfLines=0;
        _nameLabel.font=KFontA(12);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KAdaptedHeight(0));
        }];
    }
    return _nameLabel;
}



- (UIButton *)ClickBtn{
    if (!_ClickBtn) {
        _ClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ClickBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ClickBtn];
        [_ClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _ClickBtn;
}

-(void)BtnClick{
    if(self.BtnBlock){
        self.BtnBlock(self.ClickBtn.tag);
    }
    
}

@end
