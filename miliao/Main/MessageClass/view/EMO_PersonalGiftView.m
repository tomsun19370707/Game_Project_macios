//
//  EMO_PersonalGiftView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalGiftView.h"

@interface EMO_PersonalGiftView()

Strong UIView *showBgView;
Strong UIView *bgView;
Strong UIImageView *imageView;
Strong UILabel *contentLabel;



@end


@implementation EMO_PersonalGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        [self showBgView];
        [self bgView];
        [self imageView];
        [self contentLabel];
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"gift_image"]]]];
    self.contentLabel.text=[NSString stringWithFormat:@"%@*%@",dicData[@"gift_name"],dicData[@"gift_num"]];
}

- (UIView *)showBgView{
    if (!_showBgView) {
        _showBgView = [[UIView alloc] init];
        _showBgView.layer.shadowColor = RGBA(162, 162, 162, 0.16).CGColor;
        _showBgView.layer.shadowOffset = CGSizeMake(0,0);
        _showBgView.layer.shadowOpacity = 1;
        _showBgView.layer.shadowRadius = 3;
        [self addSubview:_showBgView];
        [_showBgView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(KAdaptedHeight(5));
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
            make.bottom.mas_equalTo(KAdaptedWidth(-5));
        }];
    }
    return _showBgView;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self.showBgView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}

- (UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image=KGetImage(@"gift1Img");
        [self.bgView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedWidth(10));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(35), KAdaptedHeight(40)));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imageView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"棒棒糖*88";
        _contentLabel.font=KFontA(12);
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(KAdaptedHeight(6));
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(-10));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.bgView.mas_trailing).offset(KAdaptedWidth(0));
            
        }];
    }
    return _contentLabel;
}








@end
