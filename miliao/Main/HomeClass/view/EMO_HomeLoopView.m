//
//  EMO_HomeLoopView.m
//  miliao
//
//  Created by 张世浩 on 2023/6/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_HomeLoopView.h"

@interface EMO_HomeLoopView()
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *tipLabel;
Strong UIImageView *toHeadImgView;
Strong UILabel *toNameLabel;
Strong UIView *lineView;
Strong UIImageView *giftImgView;
Strong UILabel *giftLabel;

@end

@implementation EMO_HomeLoopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=kWhiteColor;
        [self bgView];
        [self headImgView];
        [self nameLabel];
        [self tipLabel];
        [self toHeadImgView];
        [self toNameLabel];
        [self lineView];
        [self giftImgView];
        [self giftLabel];
        
        
        
    }
    return self;
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"from_user_avatar"]]]placeholderImage:KGetImage(@"manDefaultImg")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"from_user_nickname"]];
    [self.toHeadImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"to_user_avatar"]]]placeholderImage:KGetImage(@"womanDefaultImg")];
    self.toNameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"to_user_nickname"]];
    [self.giftImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"gift_image"]]]placeholderImage:KGetImage(@"giftIconImg")];
    self.giftLabel.text=[NSString stringWithFormat:@"%@x%@",dicData[@"gift_name"],dicData[@"gift_num"]];
    
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"manDefaultImg");
        _headImgView.layer.cornerRadius=KAdaptedWidth(15);
        _headImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(10));
            make.width.height.mas_equalTo(KAdaptedWidth(30));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(13);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.width.mas_equalTo(KAdaptedWidth(55));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"打赏");
        _tipLabel.textColor = RGBA(255, 111, 0, 1);
        _tipLabel.font=KFontBold(13);
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(KAdaptedWidth(5));
            make.width.mas_equalTo(KAdaptedWidth(30));
            
        }];
    }
    return _tipLabel;
}

- (UIImageView*)toHeadImgView{
    if (!_toHeadImgView) {
        _toHeadImgView = [[UIImageView alloc] init];
        _toHeadImgView.image=KGetImage(@"womanDefaultImg");
        _toHeadImgView.layer.cornerRadius=KAdaptedWidth(15);
        _toHeadImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_toHeadImgView];
        [_toHeadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(self.tipLabel.mas_trailing).offset(KAdaptedWidth(3));
            make.width.height.mas_equalTo(KAdaptedWidth(30));
            
        }];
    }
    return _toHeadImgView;
}

- (UILabel *)toNameLabel{
    if (!_toNameLabel) {
        _toNameLabel = [[UILabel alloc] init];
        _toNameLabel.text = getLanguage(@"昵称");
        _toNameLabel.textColor = RGBA(51, 51, 51, 1);
        _toNameLabel.font=KFont(13);
        [self.bgView addSubview:_toNameLabel];
        [_toNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            make.leading.mas_equalTo(self.toHeadImgView.mas_trailing).offset(KAdaptedWidth(5));
            make.width.mas_equalTo(self.nameLabel.mas_width);
            
        }];
    }
    return _toNameLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(241, 241, 241, 1);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            make.leading.mas_equalTo(self.toNameLabel.mas_trailing).offset(KAdaptedWidth(3));
            make.width.mas_equalTo(KAdaptedWidth(1));
        }];
        
    }
    return _lineView;
}




- (UIImageView*)giftImgView{
    if (!_giftImgView) {
        _giftImgView = [[UIImageView alloc] init];
        _giftImgView.image=KGetImage(@"giftIconImg");
//        _giftImgView.layer.cornerRadius=KAdaptedWidth(15);
//        _giftImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_giftImgView];
        [_giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(self.toNameLabel.mas_trailing).offset(KAdaptedWidth(8));
            make.width.height.mas_equalTo(KAdaptedWidth(25));
            
        }];
    }
    return _giftImgView;
}

- (UILabel *)giftLabel{
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc] init];
        _giftLabel.text = getLanguage(@"礼物X0");
        _giftLabel.textColor = RGBA(255, 111, 0, 1);
        _giftLabel.font=KFont(13);
        _giftLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_giftLabel];
        [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
//            make.width.mas_equalTo(KAdaptedWidth(65));
            make.leading.mas_equalTo(self.giftImgView.mas_trailing);
            
        }];
    }
    return _giftLabel;
}






@end
