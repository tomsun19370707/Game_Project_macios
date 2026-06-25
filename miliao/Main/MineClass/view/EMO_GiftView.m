//
//  EMO_GiftView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_GiftView.h"


@interface EMO_GiftView()

//Strong UIView *bgView;
//Strong UILabel *numLabel;
//Strong UILabel *tipLabel;
//Strong UIButton *giftBtn;

Strong UIImageView *iconImgView;
Strong UILabel *numLabel;
Strong UILabel *nameLabel;


@end


@implementation EMO_GiftView




- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
//        self.backgroundColor= RGBA(248, 248, 248, 1);
    }
    return self;
}



- (void)initView{
    [self iconImgView];
    [self nameLabel];
    [self numLabel];
    
//    [self bgView];
//    [self tipLabel];
//    [self numLabel];
//    [self giftBtn];
    
    
    
}


-(void)setDiData:(NSDictionary *)diData{
    _diData=diData;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",diData[@"img"]]] placeholderImage:KGetImage(@"未加载图片")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",diData[@"giftName"]];
    self.numLabel.text =[NSString stringWithFormat:@"x%@",diData[@"sum"]];
    
}

-(void)setBackDicData:(NSDictionary *)BackDicData{
    _BackDicData=BackDicData;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BackDicData[@"gift_image"]]] placeholderImage:KGetImage(@"未加载图片")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",[Common isNull:BackDicData[@"gift_name"]]];
    self.numLabel.text =[NSString stringWithFormat:@"x%@",BackDicData[@"gift_num"]];
    
    
//    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BackDicData[@"show_img"]]] placeholderImage:KGetImage(@"未加载图片")];
//    self.nameLabel.text=[NSString stringWithFormat:@"%@",[Common isNull:BackDicData[@"name"]]];
//    self.numLabel.text =[NSString stringWithFormat:@"x%@",BackDicData[@"num"]];
    
    
    
    
}

//- (UIView *)bgView{
//    if (!_bgView) {
//        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = [UIColor whiteColor];
//        _bgView.layer.cornerRadius=KAdaptedHeight(10);
//        _bgView.layer.masksToBounds=YES;
//        [self addSubview:_bgView];
//        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(KAdaptedWidth(15));
//            make.trailing.mas_equalTo(KAdaptedWidth(-15));
//            make.top.mas_equalTo(KAdaptedHeight(15));
//            make.bottom.mas_equalTo(KAdaptedHeight(90));
//
//        }];
//    }
//    return _bgView;
//}
//
//- (UILabel *)tipLabel{
//    if (!_tipLabel) {
//        _tipLabel = [[UILabel alloc] init];
//        _tipLabel.text = @"礼物总数";
//        _tipLabel.textColor = RGBA(51, 51, 51, 1);
//        _tipLabel.font = KFont(13);
//        _tipLabel.textAlignment=NSTextAlignmentCenter;
//        [self.bgView addSubview:_tipLabel];
//        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.bgView.mas_centerY).offset(KAdaptedHeight(0));
//            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
//            make.height.mas_equalTo(KAdaptedHeight(25));
//
//        }];
//    }
//    return _tipLabel;
//}
//
//- (UILabel *)numLabel{
//    if (!_numLabel) {
//        _numLabel = [[UILabel alloc] init];
//        _numLabel.text = @"0";
//        _numLabel.textColor = RGBA(51, 51, 51, 1);
//        _numLabel.font = KFont(20);
//        _numLabel.textAlignment=NSTextAlignmentCenter;
//        [self.bgView addSubview:_numLabel];
//        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(KAdaptedHeight(35));
//            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
//            make.bottom.mas_equalTo(self.bgView.mas_centerY);
//
//        }];
//    }
//    return _numLabel;
//}
//
//
//- (UIButton *)giftBtn{
//    if (!_giftBtn) {
//        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_giftBtn setTitle:getLanguage(@"收到的礼物") forState:UIControlStateNormal];
//        [_giftBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//        _giftBtn.titleLabel.font=KFontA(14);
//        [_giftBtn setImage:[UIImage imageNamed:@"giftIconImg"] forState:UIControlStateNormal];
//        _giftBtn.userInteractionEnabled=NO;
//        [self addSubview:_giftBtn];
//        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(KAdaptedWidth(15));
//            make.width.mas_equalTo(KAdaptedWidth(150));
//            make.height.mas_equalTo(KAdaptedHeight(30));
//            make.top.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(15));
//
//        }];
//        [_giftBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
//    }
//    return _giftBtn;
//}
//





- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=[UIImage imageNamed:@"MedalGaoImg"];
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(8));
            make.trailing.mas_equalTo(KAdaptedWidth(-8));
            make.bottom.mas_equalTo(KAdaptedHeight(-50));

        }];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"礼物";
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font = KFont(12);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(KAdaptedHeight(9.5));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(15));

        }];
    }
    return _nameLabel;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"x0";
        _numLabel.textColor = RGBA(153, 153, 153, 1);
        _numLabel.font = KFont(12);
        _numLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-5));

        }];
    }
    return _numLabel;
}




@end
