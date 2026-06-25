//
//  EMO_SquareCollectionViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/12/27.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SquareCollectionViewCell.h"


@interface EMO_SquareCollectionViewCell()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIImageView *selectImage;
@property (nonatomic ,strong) UIImageView *iconImage;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *defaultLabel;



@end



@implementation EMO_SquareCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgView];
        [self selectImageView];
        [self selectImage];
        [self iconImage];
        [self nameLabel];
        [self priceLabel];
        [self defaultLabel];
        

    }
    
    return self;
    

}



- (void)setModel:(PackModel *)model
{
    _model = model;
    self.nameLabel.text =[Common isNull:model.name];
    self.priceLabel.text=[Common isNull:model.price];
    self.defaultLabel.text=[Common isNull:model.expiretime_text];
    
    if(model.type==1){
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }else{
        self.priceLabel.text=@"";
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    
    if ([model.is_dress intValue] == 1 ) {
        self.selectImage.hidden = NO;
    }
    else
    {
        self.selectImage.hidden = YES;
    }
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    if ([model.select intValue] == 0) {
        self.selectImageView.hidden = YES;
    }
    else
    {
        self.selectImageView.hidden = NO;
    }
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.top.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _bgView;
}

- (UIImageView*)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
//        _selectImageView.image=KGetImage(@"bag_xz_bk");
        _selectImageView.layer.borderColor=BaseMainColor.CGColor;
        _selectImageView.layer.borderWidth=2;
        [self.bgView addSubview:_selectImageView];
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(KAdaptedWidth(1));
            make.trailing.bottom.mas_equalTo(KAdaptedWidth(-1));
            
        }];
        setViewCorner(_selectImageView, KAdaptedHeight(10));
    }
    return _selectImageView;
}

- (UIImageView*)selectImage{
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc] init];
        _selectImage.image=KGetImage(@"selectImg");
        [self.bgView addSubview:_selectImage];
        [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedWidth(3));
            make.trailing.mas_equalTo(KAdaptedWidth(-3));
            make.width.height.mas_equalTo(KAdaptedHeight(16));
            
            
        }];
    }
    return _selectImage;
}

- (UIImageView*)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        [self.bgView addSubview:_iconImage];
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(11));
            make.width.height.mas_equalTo(KAdaptedWidth(65));
            make.centerX.mas_equalTo(0);
            
            
        }];
    }
    return _iconImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"默认头像框";
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(14);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImage.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(15));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"¥0.00";
        _priceLabel.textColor = RGBA(255, 61, 0, 1);
        _priceLabel.font=KFont(11);
        _priceLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _priceLabel;
}


- (UILabel *)defaultLabel{
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.text = getLanguage(@"有效期:永久");
        _defaultLabel.textColor = RGBA(153, 153, 153, 1);
        _defaultLabel.font=KFont(12);
        _defaultLabel.textAlignment=NSTextAlignmentCenter;
//        _defaultLabel.layer.borderColor=RGBA(153, 153, 153, 1).CGColor;
//        _defaultLabel.layer.borderWidth=0.5;
//        _defaultLabel.layer.cornerRadius=KAdaptedHeight(5);
//        _defaultLabel.layer.masksToBounds=YES;
        [self.bgView addSubview:_defaultLabel];
        [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(KAdaptedHeight(8));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            
            
        }];
    }
    return _defaultLabel;
}




@end
