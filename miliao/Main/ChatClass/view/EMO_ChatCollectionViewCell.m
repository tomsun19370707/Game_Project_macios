//
//  EMO_ChatCollectionViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_ChatCollectionViewCell.h"

@interface EMO_ChatCollectionViewCell()

Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *hotBtn;
Strong UIImageView *bgTypeImgView;
Strong UIImageView *typeImgView;
Strong UILabel *typeLabel;
Strong UIImageView *maiUserPhoto;
Strong UILabel *maiUserName;

@end


@implementation EMO_ChatCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgView];
        [self headImgView];
        [self bgTypeImgView];
        [self typeImgView];
        [self typeLabel];
        [self hotBtn];
        [self maiUserPhoto];
        [self maiUserName];
        [self nameLabel];
    }
    return self;
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]] placeholderImage:KGetImage(@"未加载图片")];
    
    self.nameLabel.text= [NSString stringWithFormat:@"%@",dicData[@"name"]];
    NSString *heatStr=[NSString string];
    if([dicData[@"heat"] integerValue]>10000){
        heatStr=[NSString stringWithFormat:@"  %@",dicData[@"heat_text"]];
    }else{
        heatStr=[NSString stringWithFormat:@"  %@",dicData[@"heat"]];
    }
    [self.hotBtn setTitle:heatStr forState:UIControlStateNormal];
    CGSize size=[heatStr sizeWithFont:KFont(11) With:KAdaptedWidth(80)];
    
    [self.hotBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+KAdaptedWidth(20));
    }];
    
    [self.typeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"partition_image"]]]placeholderImage:KGetImage(@"list1")];
    NSString *str=[NSString stringWithFormat:@"%@      ",dicData[@"partition_name"]];
    CGSize textWidth = [str sizeWithFont:KFont(10) maxSize:CGSizeMake(KAdaptedWidth(150), CGFLOAT_MAX)];
    self.typeLabel.text=str;
    [self.bgTypeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth.width+3);
    }];
    
    self.bgTypeImgView.hidden=NO;
   if([dicData[@"partition_pid"] integerValue]==1){
        self.bgTypeImgView.backgroundColor=RGBA(254, 121, 119, 0);
        self.bgTypeImgView.image=KGetImage(@"homeBtnBgImg");
   }else if([dicData[@"partition_pid"] integerValue]==2){
       self.bgTypeImgView.backgroundColor=RGBA(254, 121, 119, 1);
       self.bgTypeImgView.image=KGetImage(@"");
   }else{
       self.bgTypeImgView.hidden=YES;
   }
    
  
    
    
}




- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.borderColor=RGBA(234, 234, 234, 1).CGColor;
        _bgView.layer.borderWidth=KAdaptedWidth(0.5);
        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
            
        }];
    }
    return _bgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"manSelectedImg");
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedHeight(0));
//            make.bottom.mas_equalTo(KAdaptedHeight(-58));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"姓名");
        _nameLabel.textColor = RGBA(255, 255, 255, 1);
        _nameLabel.font=KFont(13);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.maiUserPhoto.mas_top).offset(KAdaptedHeight(-5));
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.bottom.mas_offset(-5);
        }];
    }
    return _nameLabel;
}

//- (UIImageView *)maiUserPhoto{
//    if (!_maiUserPhoto) {
//        _maiUserPhoto = [[UIImageView alloc] init];
//        [self.bgView addSubview:_maiUserPhoto];
//        [_maiUserPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(-5));
//            make.leading.mas_equalTo(KAdaptedWidth(5));
//            make.height.width.mas_equalTo(KAdaptedHeight(35));
//        }];
//        setViewCorner(_maiUserPhoto, 35/2);
//    }
//    return _maiUserPhoto;
//}
//
//- (UILabel *)maiUserName{
//    if (!_maiUserName) {
//        _maiUserName = [[UILabel alloc] init];
//        _maiUserName.text = getLanguage(@"");
//        _maiUserName.textColor = RGBA(255, 255, 255, 1);
//        _maiUserName.font=KFont(13);
//        [self.bgView addSubview:_maiUserName];
//        [_maiUserName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.maiUserPhoto.mas_right).offset(5);
//            make.trailing.mas_equalTo(KAdaptedWidth(-5));
//            make.height.mas_equalTo(KAdaptedHeight(25));
//            make.centerY.equalTo(self.maiUserPhoto);
//        }];
//    }
//    return _maiUserName;
//}

- (UIImageView*)bgTypeImgView{
    if (!_bgTypeImgView) {
        _bgTypeImgView = [[UIImageView alloc] init];
        _bgTypeImgView.image=KGetImage(@"homeIconImg");
        _bgTypeImgView.layer.cornerRadius=KAdaptedHeight(8);
        _bgTypeImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_bgTypeImgView];
        [_bgTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(7));
            make.leading.mas_equalTo(KAdaptedWidth(10));
            make.width.mas_equalTo(KAdaptedWidth(50));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _bgTypeImgView;
}

- (UIImageView*)typeImgView{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        _typeImgView.image=KGetImage(@"homeIconImg");
        _typeImgView.layer.cornerRadius=KAdaptedWidth(7);
        _typeImgView.layer.masksToBounds=YES;
        [self.bgTypeImgView addSubview:_typeImgView];
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(2));
            make.width.height.mas_equalTo(KAdaptedWidth(14));
            
        }];
    }
    return _typeImgView;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = getLanguage(@"情感");
        _typeLabel.textColor =kWhiteColor;
        _typeLabel.textAlignment=NSTextAlignmentRight;
        _typeLabel.font=KFont(10);
        [self.bgTypeImgView addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.typeImgView.mas_trailing).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-3));
            
        }];
    }
    return _typeLabel;
}

- (UIButton *)hotBtn{
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotBtn.backgroundColor=RGBA(255, 255, 255, 0.5);
        [_hotBtn setTitle:@" 9876" forState:UIControlStateNormal];
        [_hotBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _hotBtn.titleLabel.font=KFont(11);
        [_hotBtn setImage:[UIImage imageNamed:@"homeHotImg"] forState:UIControlStateNormal];
        _hotBtn.layer.cornerRadius=KAdaptedHeight(10);
        _hotBtn.layer.masksToBounds=YES;
        [self.bgView addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(7));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _hotBtn;
}









@end
