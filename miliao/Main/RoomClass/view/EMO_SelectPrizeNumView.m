//
//  EMO_SelectPrizeNumView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SelectPrizeNumView.h"

@interface EMO_SelectPrizeNumView ()





@end

@implementation EMO_SelectPrizeNumView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    self.titleLabel.text=[NSString stringWithFormat:@"抽%@次",dicData[@"nums"]];
    [self.priceBtm setTitle:[Common isNullNumber:dicData[@"price"]] forState:UIControlStateNormal];
    [self.priceBtm setImage:KGetImage(@"coinSmallImg") forState:UIControlStateNormal];
    [self.priceBtm setImagePositionWithType:0 spacing:3];
    
}


-(void)initView{
    [self bgImageView];
    [self titleLabel];
    [self priceBtm];
    
}


- (UIImageView*)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image=KGetImage(@"GamebtnBgImg3");
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"抽1次";
        _titleLabel.textColor = RGBA(129, 109, 172, 1);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=KFontA(14);
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_centerY);
        }];
    }
    return _titleLabel;
}


- (UIButton *)priceBtm{
    if (!_priceBtm) {
        _priceBtm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceBtm setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        [_priceBtm setImage:KGetImage(@"coinSmallImg") forState:UIControlStateNormal];
        [_priceBtm setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _priceBtm.titleLabel.font=KFontA(12);
        [self addSubview:_priceBtm];
        [_priceBtm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.leading.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedWidth(-5));
        }];
        [_priceBtm setImagePositionWithType:0 spacing:3];
    }
    return _priceBtm;
}



@end
