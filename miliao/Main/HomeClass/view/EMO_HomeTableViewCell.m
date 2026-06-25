//
//  EMO_HomeTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2023/6/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_HomeTableViewCell.h"

@interface EMO_HomeTableViewCell()
Strong UIView *showBgView;
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
//Strong UIButton *typeBtn;
Strong UIImageView *bgTypeImgView;
Strong UIImageView *typeImgView;
Strong UIView *lockView;//背景锁
Strong UIImageView *lockImg;//背景锁
Strong UILabel *typeLabel;
Strong UIButton *hotBtn;


@end

@implementation EMO_HomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=RGBA(1, 1, 1, 0);
        self.contentView.backgroundColor=RGBA(246, 246, 246, 0);
        [self showBgView];
        [self bgView];
        [self headImgView];
        [self nameLabel];
//        [self typeBtn];
        [self bgTypeImgView];
        [self typeImgView];
        [self typeLabel];
        [self hotBtn];
        [self lockImg];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
//    status;//0未开播1禁播2在播
//    type; 是否有密码 0没有1有
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]]placeholderImage:KGetImage(@"list1")];
    self.nameLabel.text=[Common isNull:dicData[@"name"]];
    if([dicData[@"heat"] integerValue]>10000){
        [self.hotBtn setTitle:[NSString stringWithFormat:@"  %@",dicData[@"heat_text"]] forState:UIControlStateNormal];
    }else{
        [self.hotBtn setTitle:[NSString stringWithFormat:@"  %@",dicData[@"heat"]] forState:UIControlStateNormal];
    }
    
    [self.typeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"partition_image"]]]placeholderImage:KGetImage(@"list1")];
    
    NSString *str=[NSString stringWithFormat:@"%@      ",dicData[@"partition_name"]];
    CGSize textWidth = [str sizeWithFont:KFont(10) maxSize:CGSizeMake(KAdaptedWidth(150), CGFLOAT_MAX)];
//    [self.typeBtn setTitle:str forState:UIControlStateNormal];
//    [self.typeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(textWidth.width+5);
//
//    }];
    self.typeLabel.text=str;
    [self.bgTypeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth.width+3);
    }];
   if([dicData[@"partition_pid"] integerValue]==1){
        self.bgTypeImgView.backgroundColor=RGBA(254, 121, 119, 0);
        self.bgTypeImgView.image=KGetImage(@"homeBtnBgImg");
   }else{
       self.bgTypeImgView.backgroundColor=RGBA(254, 121, 119, 1);
       self.bgTypeImgView.image=KGetImage(@"");
   }
    //是否加锁
    if([dicData[@"type"] integerValue]==1){
        self.lockView.hidden = NO;
    }else{
        self.lockView.hidden = YES;
    }
    
}


- (UIView *)showBgView{
    if (!_showBgView) {
        _showBgView = [[UIView alloc] init];
        _showBgView.layer.shadowColor = RGBA(162, 162, 162, 0.16).CGColor;
        _showBgView.layer.shadowOffset = CGSizeMake(0,0);
        _showBgView.layer.shadowOpacity = 1;
        _showBgView.layer.shadowRadius = 3;
        [self.contentView addSubview:_showBgView];
        [_showBgView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedWidth(-5));
        }];
    }
    return _showBgView;
}

- (UIView *)lockView{
    if (!_lockView) {
        _lockView = [[UIView alloc] init];
        _lockView.hidden = YES;
        _lockView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self.bgView addSubview:_lockView];
        [_lockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(6));
            make.width.height.mas_equalTo(KAdaptedWidth(65));
        }];
        
        _lockImg = [[UIImageView alloc] init];
        _lockImg.image = KGetImage(@"UY_Lock");
        [self.lockView addSubview:_lockImg];
        [_lockImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(26));
        }];
    }
    return _lockView;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = RGBA(255, 241, 217, 1).CGColor;
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


- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"list1");
        _headImgView.layer.cornerRadius=KAdaptedWidth(8);
        _headImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(6));
            make.width.height.mas_equalTo(KAdaptedWidth(65));
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(14);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
    }
    return _nameLabel;
}


//- (UIButton *)typeBtn{
//    if (!_typeBtn) {
//        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _typeBtn.backgroundColor=RGBA(254, 121, 119, 1);
//        [_typeBtn setTitle:getLanguage(@" 情感") forState:UIControlStateNormal];
//        [_typeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [_typeBtn setImage:[UIImage imageNamed:@"homeIconImg1"] forState:UIControlStateNormal];
//        _typeBtn.titleLabel.font=KFont(10);
//        _typeBtn.layer.cornerRadius=KAdaptedHeight(8);
//        _typeBtn.layer.masksToBounds=YES;
//        _typeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
//        [self.bgView addSubview:_typeBtn];
//        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(KAdaptedWidth(45));
//            make.height.mas_equalTo(KAdaptedHeight(16));
//            make.leading.mas_equalTo(self.nameLabel.mas_leading);
//            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(6));
//
//        }];
//    }
//    return _typeBtn;
//}

- (UIImageView*)bgTypeImgView{
    if (!_bgTypeImgView) {
        _bgTypeImgView = [[UIImageView alloc] init];
        _bgTypeImgView.image=KGetImage(@"homeIconImg");
        _bgTypeImgView.layer.cornerRadius=KAdaptedHeight(8);
        _bgTypeImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_bgTypeImgView];
        [_bgTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.height.mas_equalTo(KAdaptedHeight(16));
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(6));
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
        [_hotBtn setTitle:getLanguage(@"  1000") forState:UIControlStateNormal];
        [_hotBtn setTitleColor:RGBA(255, 109, 87, 1) forState:UIControlStateNormal];
        [_hotBtn setImage:[UIImage imageNamed:@"homeHotImg"] forState:UIControlStateNormal];
        _hotBtn.titleLabel.font=KFont(10);
        _hotBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(20)));
            make.trailing.mas_equalTo(KAdaptedWidth(-13));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            
        }];
    }
    return _hotBtn;
}






@end
