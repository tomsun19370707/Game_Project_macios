//
//  EMO_PersonalGradeView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalGradeView.h"

@interface EMO_PersonalGradeView()

Strong UIView *showBgView;
Strong UIView *bgView;
Strong UIImageView *imageView;
Strong UILabel *contentLabel;


Strong UIButton *gradeBtn;


@end

@implementation EMO_PersonalGradeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        [self showBgView];
        [self bgView];
//        [self gradeBtn];
        [self imageView];
        [self contentLabel];
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    NSString *imageUrl=[Common isNull:dicData[@"image"]];
    if([imageUrl hasPrefix:@"http"]){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }else{
        self.imageView.image=KGetImage(imageUrl);
    }
    self.contentLabel.text=[Common isNull:dicData[@"name"]];
    
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
        _imageView.image=KGetImage(@"level4Img");
        [self.bgView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedWidth(5));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedHeight(30)));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imageView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"魅力等级\n0";
        _contentLabel.font=KFont(13);
        _contentLabel.numberOfLines=0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(8);
            make.bottom.mas_equalTo(-5);
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
        }];
    }
    return _contentLabel;
}





- (UIButton *)gradeBtn{
    if (!_gradeBtn) {
        _gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gradeBtn setTitle:@"魅力等级\n0" forState:UIControlStateNormal];
        [_gradeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _gradeBtn.titleLabel.font=KFontA(13);
        [_gradeBtn setImage:[UIImage imageNamed:@"level4Img"] forState:UIControlStateNormal];
        _gradeBtn.titleLabel.numberOfLines=0;
        [self.bgView addSubview:_gradeBtn];
        [_gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(24));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(120), KAdaptedHeight(35)));
        }];
        [_gradeBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    }
    return _gradeBtn;
}




@end
